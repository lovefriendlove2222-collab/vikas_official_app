import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GenericServiceForm extends StatefulWidget {
  final String serviceTitle; // योजना का नाम
  final String userId;

  GenericServiceForm({required this.serviceTitle, required this.userId});

  @override
  _GenericServiceFormState createState() => _GenericServiceFormState();
}

class _GenericServiceFormState extends State<GenericServiceForm> {
  final _detailsController = TextEditingController();
  bool _isLoading = false;

  void _submitApplication() async {
    if (_detailsController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('applications').add({
        "service_name": widget.serviceTitle,
        "user_id": widget.userId,
        "details": _detailsController.text,
        "status": "pending",
        "created_at": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.serviceTitle} के लिए आवेदन सफल!"))
      );
      Navigator.pop(context); // फॉर्म जमा होने के बाद वापस होम पर जाएं
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      app_appBar: AppBar(title: Text(widget.serviceTitle)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("आवेदन विवरण लिखें:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _detailsController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "जैसे: नाम, पिता का नाम, आधार नंबर आदि...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading 
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: _submitApplication,
                    child: Text("आवेदन जमा करें", style: TextStyle(color: Colors.white)),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
