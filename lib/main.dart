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
      title: 'Vikas Pasoria Official',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: LoginScreen(),
    );
  }
}

// --- LOGIN SCREEN ---
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();

  void login() async {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) return;

    var db = FirebaseFirestore.instance;
    var doc = await db.collection("users").doc(phone).get();

    if (!doc.exists) {
      await db.collection("users").doc(phone).set({
        "mobile": phone,
        "approved": false,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("पंजीकरण सफल! एडमिन की मंजूरी का इंतज़ार करें।")));
    } else {
      if (doc['approved'] == true) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen(phone)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("आपकी आईडी अभी मंजूर नहीं हुई है।")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("विकास पासोरिया - लॉगिन")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "मोबाइल नंबर"), keyboardType: TextInputType.phone),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text("लॉगिन / रजिस्टर"))
          ],
        ),
      ),
    );
  }
}

// --- HOME SCREEN ---
class HomeScreen extends StatelessWidget {
  final String userId;
  HomeScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("होम - विकास पासोरिया")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('menus').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          return GridView.count(
            crossAxisCount: 2,
            children: snap.data!.docs.map((m) {
              return Card(
                child: InkWell(
                  onTap: () {
                    if (m['type'] == "donation") {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => DonationScreen(userId)));
                    }
                  },
                  child: Center(child: Text(m['title'], style: TextStyle(fontWeight: FontWeight.bold))),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

// --- DONATION SCREEN ---
class DonationScreen extends StatelessWidget {
  final String userId;
  DonationScreen(this.userId);
  final amountController = TextEditingController();

  void donate(context) async {
    await FirebaseFirestore.instance.collection('donations').add({
      "user_id": userId,
      "amount": amountController.text,
      "status": "pending",
      "timestamp": FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("भुगतान अनुरोध भेजा गया!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("दान / सेवा राशि")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: amountController, decoration: InputDecoration(labelText: "राशि भरें (₹)"), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => donate(context), child: Text("पेमेंट करें"))
          ],
        ),
      ),
    );
  }
}
