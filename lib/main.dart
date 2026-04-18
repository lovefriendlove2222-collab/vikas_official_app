import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Firebase को कनेक्ट करने के लिए 5 सेकंड का समय
    await Firebase.initializeApp().timeout(const Duration(seconds: 5));
  } catch (e) {
    print("Firebase Error: $e");
  }
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VikasApp(),
  ));
}

class VikasApp extends StatelessWidget {
  const VikasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('विकास पासोरिया ऑफिसियल'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      // 'menus' कलेक्शन से डेटा उठाओ
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menus').snapshots(),
        builder: (context, snapshot) {
          
          // डिफ़ॉल्ट डेटा (अगर डेटाबेस खाली हो तो यो दिखेगा)
          String title = "हरि ॐ जी!";
          String desc = "पंडित विकास पासोरिया सांस्कृतिक एवं आध्यात्मिक पाठशाला";

          // अगर डेटा मिल गया तो उसे अपडेट करो
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
            title = data['title'] ?? title; // Firebase फील्ड 'title'
            desc = data['desc'] ?? desc;   // Firebase फील्ड 'desc'
          }

          // लोगो पर अटकने से रोकने के लिए सीधा UI दिखाओ
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Icon(Icons.fort_rounded, size: 100, color: Colors.deepOrange),
                  const SizedBox(height: 30),
                  Text(title, 
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(desc, 
                      textAlign: TextAlign.center, 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      minimumSize: const Size(250, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () => _launch("https://youtube.com/@VikasPasoriya"),
                    icon: const Icon(Icons.video_library, color: Colors.white),
                    label: const Text("यूट्यूब चैनल", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _launch(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
