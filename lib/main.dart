import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Firebase को स्टार्ट करने का सबसे बेसिक तरीका
    await Firebase.initializeApp();
    runApp(VikasApp());
  } catch (e) {
    // अगर कोई बड़ी गलती हुई, तो स्क्रीन पर लिख देगा
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text("Firebase Error: $e")))));
  }
}

class VikasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Vikas Pasoriya Official"), backgroundColor: Colors.orange),
        body: StreamBuilder(
          // 'services' की जगह 'test' कलेक्शन से चेक करते हैं
          stream: FirebaseFirestore.instance.collection('services').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
            // 1. अगर कनेक्शन में लोचा है
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("डेटाबेस से जुड़ रहा हूँ... कृपया नेट चेक करें"),
                ],
              ));
            }

            // 2. अगर कोई एरर आ जाए
            if (snap.hasError) {
              return Center(child: Text("Error: ${snap.error}"));
            }

            // 3. अगर डेटाबेस में कुछ नहीं मिला
            if (!snap.hasData || snap.data!.docs.isEmpty) {
              return Center(child: Text("डेटाबेस में कोई 'services' फोल्डर नहीं मिला!"));
            }

            // 4. अगर सब सही है, तो लिस्ट दिखाओ
            return ListView(
              children: snap.data!.docs.map((d) => ListTile(
                title: Text(d['title'] ?? "No Title"),
                leading: Icon(Icons.star, color: Colors.orange),
              )).toList(),
            );
          },
        ),
      ),
    );
  }
}
