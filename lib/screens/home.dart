import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("विकास पासोरिया - सेवाएं"), backgroundColor: Colors.orange),
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
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // जानकारी वाली स्क्रीन पर ले जाना
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(doc['title']),
                        content: Text(doc['desc'] ?? "जानकारी जल्द उपलब्ध होगी।"),
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
