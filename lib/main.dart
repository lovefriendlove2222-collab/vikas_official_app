import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(VikasMemberApp());
}

class VikasMemberApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  // फॉर्म के लिए वेरिएबल्स
  String name = '', village = '', city = '', state = '', work = '', mobile = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vikas App - मेंबर रजिस्ट्रेशन")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("आईडी कार्ड के लिए जानकारी भरें", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextFormField(decoration: InputDecoration(labelText: 'पूरा नाम'), onChanged: (v) => name = v),
              TextFormField(decoration: InputDecoration(labelText: 'गाँव'), onChanged: (v) => village = v),
              TextFormField(decoration: InputDecoration(labelText: 'शहर'), onChanged: (v) => city = v),
              TextFormField(decoration: InputDecoration(labelText: 'राज्य'), onChanged: (v) => state = v),
              TextFormField(decoration: InputDecoration(labelText: 'आप क्या काम करते हैं?'), onChanged: (v) => work = v),
              TextFormField(decoration: InputDecoration(labelText: 'मोबाइल नंबर'), keyboardType: TextInputType.phone, onChanged: (v) => mobile = v),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // डेटा Firebase में भेजना
                  FirebaseFirestore.instance.collection('members').add({
                    'name': name,
                    'village': village,
                    'city': city,
                    'state': state,
                    'work': work,
                    'mobile': mobile,
                    'status': 'Pending', // एडमिन अप्रूव करेगा
                    'post': 'Waiting',   // एडमिन पद देगा
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("रजिस्ट्रेशन सफल! एडमिन के अप्रूवल का इंतज़ार करें।")));
                },
                child: Text("सबमिट करें"),
              ),
              Divider(height: 40),
              // डोनेशन बटन
              ListTile(
                leading: Icon(Icons.qr_code, color: Colors.orange),
                title: Text("डोनेशन / सहयोग दें"),
                onTap: () {
                  // यहाँ QR कोड वाला पेज खुलेगा
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
