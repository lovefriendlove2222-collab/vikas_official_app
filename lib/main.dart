import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // फायरबेस चालू करना
  runApp(VikasApp());
}

class VikasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vikas Pasoria Official',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomeScreen(), // सीधा होम स्क्रीन पर ले जाएगा
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("विकास पासोरिया - सेवाएं")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('menus').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          
          return ListView(
            children: snap.data!.docs.map((doc) {
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(doc['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("क्लिक करके जानकारी देखें"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(doc['title']),
                        content: Text(doc['desc'] ?? "जानकारी जल्द आएगी।"),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
