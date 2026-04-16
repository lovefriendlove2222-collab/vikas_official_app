// विकास भाई, इस कोड को अपनी main.dart में पूरा बदल दें
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("जय श्री राम", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange[900])),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage())),
              child: Text("मेंबर रजिस्ट्रेशन", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => _showAdminLogin(context),
              child: Text("एडमिन लॉगिन", style: TextStyle(color: Colors.orange[900])),
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
        title: Text("पासवर्ड डालें"),
        content: TextField(controller: _pass, obscureText: true),
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

class RegistrationPage extends StatelessWidget {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController villageC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      app_bar: AppBar(title: Text("रजिस्ट्रेशन"), backgroundColor: Colors.orange[800]),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameC, decoration: InputDecoration(labelText: "नाम")),
            TextField(controller: villageC, decoration: InputDecoration(labelText: "गाँव")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('members').add({
                  'name': nameC.text,
                  'village': villageC.text,
                  'status': 'Pending'
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("सफल!")));
              },
              child: Text("सबमिट"),
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
    return Scaffold(appBar: AppBar(title: Text("एडमिन")));
  }
}
