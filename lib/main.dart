import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Firebase को लोड होने के लिए थोड़ा समय दें
    await Firebase.initializeApp();
    await Future.delayed(Duration(seconds: 2));
    runApp(VikasApp());
  } catch (e) {
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text("Error: $e")))));
  }
}

class VikasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("विकास पासोरिया ऑफिशियल"), backgroundColor: Colors.orange),
        body: StreamBuilder(
          // पक्का करें कि Firebase में 'services' नाम का कलेक्शन है
          stream: FirebaseFirestore.instance.collection('services').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Center(child: Text("कनेक्शन एरर!"));
            if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
            
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("डेटाबेस में अभी कुछ नहीं है, कृपया Firebase में डेटा डालें।"));
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return ListTile(
                  title: Text(doc['title'] ?? 'No Title'),
                  subtitle: Text(doc['type'] ?? 'No Type'),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
