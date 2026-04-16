import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(VikasUltraApp());
}

class VikasUltraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vikas Pasoriya Official',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: LoginScreen(),
    );
  }
}

// --- एडमिन द्वारा कंट्रोल होने वाला होम पेज ---
class HomeScreen extends StatelessWidget {
  final String userId;
  HomeScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("विकास पासोरिया - सेवा पोर्टल"), centerTitle: true),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('services').orderBy('order').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          
          return ListView(
            children: [
              // लाइव सेक्शन (अगर एडमिन ने लाइव ऑन किया है)
              _buildLiveBanner(),
              
              // सर्विस ग्रिड (यहाँ आपकी 100+ सर्विसेज आएँगी)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: snap.data!.docs.length,
                itemBuilder: (context, index) {
                  var item = snap.data!.docs[index];
                  return Card(
                    child: InkWell(
                      onTap: () => _handleService(context, item),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stars, color: Colors.orange, size: 40),
                          Text(item['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleService(context, doc) {
    // अगर टाइप यूट्यूब है तो वीडियो खोलें, डोनेशन है तो पेमेंट पर ले जाएं
    if (doc['type'] == 'youtube') launchUrl(Uri.parse(doc['url']));
    if (doc['type'] == 'donation') /* Payment Screen Logic */ ;
  }

  Widget _buildLiveBanner() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('status').doc('live').snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
        if (!snap.hasData || snap.data!['isLive'] == false) return SizedBox();
        return Container(
          color: Colors.red,
          padding: EdgeInsets.all(10),
          child: Row(children: [Icon(Icons.live_tv, color: Colors.white), Text(" विकास भाई लाइव हैं!", style: TextStyle(color: Colors.white))]),
        );
      },
    );
  }
}

// --- लॉगिन स्क्रीन (पुराना वाला ही रहेगा) ---
class LoginScreen extends StatefulWidget {
  @override _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final phone = TextEditingController();
  void login() async {
    var doc = await FirebaseFirestore.instance.collection("users").doc(phone.text).get();
    if (doc.exists && doc['approved'] == true) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(phone.text)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("मंजूरी का इंतज़ार करें")));
    }
  }
  @override Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("विकास पासोरिया", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      TextField(controller: phone, decoration: InputDecoration(hintText: "नंबर लिखें")),
      ElevatedButton(onPressed: login, child: Text("प्रवेश करें"))
    ])));
  }
}
