import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("विकास पासोरिया ऑफिशियल"), backgroundColor: Colors.orange[900]),
      body: Container(
        color: Colors.orange[50],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🚩 जय श्री राम 🚩", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange[900])),
              SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage())),
                icon: Icon(Icons.person_add, color: Colors.white),
                label: Text("मेंबर रजिस्ट्रेशन", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => _showAdminLogin(context),
                child: Text("एडमिन लॉगिन", style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold)),
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
            }
          }, child: Text("लॉगिन"))
        ],
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String name = '', village = '', mobile = '', work = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("मेंबरशिप फॉर्म"), backgroundColor: Colors.orange[800]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: "आपका नाम"), onChanged: (v) => name = v),
            TextField(decoration: InputDecoration(labelText: "गाँव / शहर"), onChanged: (v) => village = v),
            TextField(decoration: InputDecoration(labelText: "व्यवसाय"), onChanged: (v) => work = v),
            TextField(decoration: InputDecoration(labelText: "मोबाइल नंबर"), keyboardType: TextInputType.phone, onChanged: (v) => mobile = v),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[900], minimumSize: Size(double.infinity, 50)),
              onPressed: () async {
                if (name.isEmpty || mobile.isEmpty) return;
                await FirebaseFirestore.instance.collection('members').add({
                  'name': name, 'village': village, 'mobile': mobile, 'work': work,
                  'status': 'Pending', 'post': 'सदस्य'
                });
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

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("एडमिन पैनल"), backgroundColor: Colors.black87),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('members').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Card(
                child: ListTile(
                  title: Text(doc['name']),
                  subtitle: Text("${doc['village']} - ${doc['status']}"),
                  trailing: doc['status'] == 'Pending' ? ElevatedButton(
                    onPressed: () => FirebaseFirestore.instance.collection('members').doc(doc.id).update({'status': 'Approved'}),
                    child: Text("Approve"),
                  ) : Icon(Icons.check, color: Colors.green),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
