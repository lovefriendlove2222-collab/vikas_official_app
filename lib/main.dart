import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // 1. ऐप के इंजन को स्टार्ट करना
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 2. Firebase को लोड करना
    await Firebase.initializeApp();
    
    // 3. थोड़ा इंतज़ार ताकि डेटाबेस से कनेक्शन पक्का हो जाए (Null-Error फिक्स)
    await Future.delayed(Duration(seconds: 2));
    
    runApp(VikasUltraApp());
  } catch (e) {
    // अगर कोई बड़ी गड़बड़ हो तो यहाँ दिखेगी
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Firebase Error: $e", style: TextStyle(color: Colors.red))),
      ),
    ));
  }
}

class VikasUltraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vikas Pasoriya Official',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: TestHomeScreen(),
    );
  }
}

class TestHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("विकास पासोरिया - होम"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: StreamBuilder(
        // पक्का करें कि आपके Firebase में 'services' नाम का कलेक्शन है
        stream: FirebaseFirestore.instance.collection('services').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
          
          // अगर कोई एरर आए (जैसे Rules की दिक्कत)
          if (snap.hasError) {
            return Center(child: Text("डेटाबेस से संपर्क नहीं हुआ: ${snap.error}"));
          }

          // जब तक डेटा लोड हो रहा है
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // अगर कलेक्शन खाली है
          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return Center(
              child: Text("डेटाबेस खाली है! कृपया Firebase में 'services' फोल्डर बनाएँ।"),
            );
          }

          // सब सही है तो लिस्ट दिखाओ
          return ListView.builder(
            itemCount: snap.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snap.data!.docs[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Icon(Icons.star, color: Colors.orange),
                  title: Text(doc['title'] ?? "बिना नाम की सर्विस"),
                  subtitle: Text(doc['type'] ?? "No Type"),
                  onTap: () {
                    // यहाँ क्लिक करने पर क्या होगा वो बाद में जोड़ेंगे
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
