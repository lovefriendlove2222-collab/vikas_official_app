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
      title: 'विकास पासोरिया ऑफिशियल',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: LandingPage(),
    );
  }
}

// --- मुख्य पेज ---
class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("विकास पासोरिया ऑफिशियल"), backgroundColor: Colors.orange[900]),
      body: Container(
        decoration: BoxDecoration(color: Colors.orange[50]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network('https://via.placeholder.com/150', height: 100), // यहाँ अपना लोगो लगा सकते हैं
              SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage())),
                icon: Icon(Icons.person_add, color: Colors.white),
                label: Text("मेंबर रजिस्ट्रेशन", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => _showAdminLogin(context),
                child: Text("एडमिन लॉगिन (विकास भाई)", style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAdminLogin(context) {
    TextEditingController _pass = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("सुरक्षित लॉगिन"),
        content: TextField(controller: _pass, obscureText: true, decoration: InputDecoration(hintText: "पासवर्ड डालें")),
        actions: [
          ElevatedButton(onPressed: () {
            if (_pass.text == "1008@pasoriya") {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanel()));
            } else {
              print("गलत पासवर्ड");
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
  bool isUploading = false;

  Future pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() { if (pickedFile != null) _image = File(pickedFile.path); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("मेंबरशिप फॉर्म"), backgroundColor: Colors.orange[800]),
      body: isUploading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.orange[100],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Icon(Icons.camera_alt, size: 40, color: Colors.orange[800]) : null,
              ),
            ),
            SizedBox(height: 10),
            Text("अपनी फोटो चुनें", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(decoration: InputDecoration(labelText: "आपका नाम"), onChanged: (v) => name = v),
            TextField(decoration: InputDecoration(labelText: "गाँव / शहर"), onChanged: (v) => village = v),
            TextField(decoration: InputDecoration(labelText: "व्यवसाय (क्या काम करते हो)"), onChanged: (v) => work = v),
            TextField(decoration: InputDecoration(labelText: "मोबाइल नंबर"), keyboardType: TextInputType.phone, onChanged: (v) => mobile = v),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[900], minimumSize: Size(double.infinity, 50)),
              onPressed: () async {
                if (name.isEmpty || mobile.isEmpty) return;
                setState(() => isUploading = true);
                
                String photoUrl = "";
                if (_image != null) {
                  var snapshot = await FirebaseStorage.instance.ref().child('members/${DateTime.now()}.jpg').putFile(_image!);
                  photoUrl = await snapshot.ref.getDownloadURL();
                }

                await FirebaseFirestore.instance.collection('members').add({
                  'name': name, 'village': village, 'mobile': mobile, 'work': work,
                  'photo': photoUrl, 'status': 'Pending', 'post': 'सदस्य'
                });

                setState(() => isUploading = false);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("सफल! एडमिन के अप्रूवल का इंतज़ार करें।")));
              },
              child: Text("जानकारी सबमिट करें", style: TextStyle(color: Colors.white)),
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
      appBar: AppBar(title: Text("एडमिन कंट्रोल पैनल"), backgroundColor: Colors.black87),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('members').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(doc['photo'] ?? '')),
                  title: Text(doc['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${doc['village']} - ${doc['status']}"),
                  trailing: doc['status'] == 'Pending' ? ElevatedButton(
                    onPressed: () => _approveMember(context, doc.id),
                    child: Text("Approve"),
                  ) : Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _approveMember(context, docId) {
    TextEditingController _post = TextEditingController(text: "मुख्य सदस्य");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("पद अलॉट करें"),
        content: TextField(controller: _post, decoration: InputDecoration(hintText: "जैसे: प्रधान, सचिव, सदस्य")),
        actions: [
          ElevatedButton(onPressed: () {
            FirebaseFirestore.instance.collection('members').doc(docId).update({
              'status': 'Approved',
              'post': _post.text
            });
            Navigator.pop(context);
          }, child: Text("कंफर्म करें"))
        ],
      ),
    );
  }
}
