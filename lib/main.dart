import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // 1. ऐप को बाइंड करना (जरूरी है)
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 2. Firebase को लोड करना
    await Firebase.initializeApp();
    runApp(VikasApp());
  } catch (e) {
    // अगर फिर भी कोई एरर आए तो यहाँ दिखेगा
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text("Firebase लोड नहीं हुआ: $e")))));
  }
}

class VikasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Vikas Pasoriya Official"),
          backgroundColor: Colors.orange,
        ),
        body: StreamBuilder(
          // पक्का करें कि Firebase में 'services' नाम का फोल्डर है
          stream: FirebaseFirestore.instance.collection('services').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
            if (snap.hasError) return Center(child: Text("डेटाबेस एरर: ${snap.error}"));
            if (snap.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
            
            if (!snap.hasData || snap.data!.docs.isEmpty) {
              return Center(child: Text("डेटाबेस में कोई सर्विस नहीं मिली!"));
            }

            return ListView(
              children: snap.data!.docs.map((doc) {
                return ListTile(
                  leading: Icon(Icons.star, color: Colors.orange),
                  title: Text(doc['title'] ?? "No Title"),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
