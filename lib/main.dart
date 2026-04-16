import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(VikasApp());
}

class VikasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: LandingPage(),
    );
  }
}

// --- लैंडिंग पेज (शुरुआती स्क्रीन) ---
class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("विकास पासोरिया ऑफिशियल"), backgroundColor: Colors.orange[800]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[700], padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage())),
              child: Text("मेंबर रजिस्ट्रेशन", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => _showAdminLogin(context),
              child: Text("एडमिन लॉगिन", style: TextStyle(color: Colors.grey[700])),
            )
          ],
        ),
      ),
    );
  }

  void _showAdminLogin(context) {
    TextEditingController _pass = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("एडमिन पासवर्ड डालें"),
        content: TextField(controller: _pass, obscureText: true, decoration: InputDecoration(hintText: "यहाँ पासवर्ड लिखें")),
        actions: [
          TextButton(onPressed: () {
            if (_pass.text == "1008@pasoriya") {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanel()));
            }
          }, child: Text("लॉगिन"))
        ],
      ),
    );
  }
}

// --- रजिस्ट्रेशन पेज ---
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _picker = ImagePicker();
  File? _image;
  String name = '', village = '', mobile = '', work = '';

  Future pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() { if (pickedFile != null) _image = File(pickedFile.path); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("नया मेंबर बनें"), backgroundColor: Colors.orange[800]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange[100],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Icon(Icons.add_a_photo, size: 40, color: Colors.orange) : null,
              ),
            ),
            Text("फोटो चुनें", style: TextStyle(color: Colors.orange)),
            TextField(decoration: InputDecoration(labelText: "पूरा नाम"), onChanged: (v) => name = v),
            TextField(decoration: InputDecoration(labelText: "गाँव/शहर"), onChanged: (v) => village = v),
            TextField(decoration: InputDecoration(labelText: "काम"), onChanged: (v) => work = v),
            TextField(decoration: InputDecoration(labelText: "मोबाइल नंबर"), keyboardType: TextInputType.phone, onChanged: (v) => mobile = v),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800]),
              onPressed: () async {
                // यहाँ फोटो अपलोड और डेटा सेव की कोडिंग आएगी
                await FirebaseFirestore.instance.collection('members').add({
                  'name': name, 'village': village, 'mobile': mobile, 'work': work,
                  'status': 'Pending', 'post': 'सदस्य', 'photo': '' 
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("सफल! एडमिन अप्रूवल के बाद आईडी दिखेगी।")));
                Navigator.pop(context);
              },
              child: Text("सबमिट करें", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

// --- एडमिन पैनल ---
class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("एडमिन कंट्रोल"), backgroundColor: Colors.black87),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('members').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['name']),
                subtitle: Text("${doc['village']} - ${doc['status']}"),
                trailing: ElevatedButton(
                  onPressed: () => FirebaseFirestore.instance.collection('members').doc(doc.id).update({'status': 'Approved', 'post': 'मुख्य सदस्य'}),
                  child: Text("Approve"),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
