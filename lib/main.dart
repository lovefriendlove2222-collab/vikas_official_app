import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // 2 सेकंड का टाइमआउट ताकि ऐप अटके नहीं
    await Firebase.initializeApp().timeout(const Duration(seconds: 2));
  } catch (e) {
    debugPrint("Firebase connection skipped for speed");
  }
  runApp(const VikasApp());
}

class VikasApp extends StatelessWidget {
  const VikasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'विकास पासोरिया ऑफिशियल',
      theme: ThemeData(primarySwatch: Colors.orange, scaffoldBackgroundColor: Colors.white),
      home: const LandingPage(),
    );
  }
}

// --- 1. मुख्य स्क्रीन (Landing Page) ---
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("विकास पासोरिया ऑफिशियल"),
        backgroundColor: Colors.orange[900],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => _showAdminLogin(context),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange[100]!, Colors.white], begin: Alignment.topCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🚩 जय श्री राम 🚩", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 10),
            const Text("लोकगायक विकास पासोरिया", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage())),
              child: const Text("मेंबर रजिस्ट्रेशन", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdminLogin(BuildContext context) {
    TextEditingController pass = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("एडमिन लॉगिन"),
        content: TextField(controller: pass, decoration: const InputDecoration(hintText: "पासवर्ड डालें"), obscureText: true),
        actions: [
          TextButton(onPressed: () {
            if (pass.text == "1008@pasoriya") {
              Navigator.pop(context);
              // यहाँ एडमिन पेज खोल सकते हैं
            }
          }, child: const Text("लॉगिन"))
        ],
      ),
    );
  }
}

// --- 2. रजिस्ट्रेशन पेज (Registration Page) ---
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _village = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _work = TextEditingController();

  void _saveData() async {
    if (_name.text.isEmpty || _phone.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("नाम और नंबर ज़रूरी है!")));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('members').add({
        'name': _name.text,
        'village': _village.text,
        'work': _work.text,
        'phone': _phone.text,
        'date': DateTime.now().toString(),
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("सफल!"),
            content: const Text("आपकी जानकारी सेव हो गई है। जय श्री राम!"),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("ठीक है"))],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("इंटरनेट चेक करें!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("मेंबर रजिस्ट्रेशन"), backgroundColor: Colors.orange[800]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            TextField(controller: _name, decoration: const InputDecoration(labelText: "आपका नाम", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _village, decoration: const InputDecoration(labelText: "गाँव / शहर", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _work, decoration: const InputDecoration(labelText: "व्यवसाय", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "मोबाइल नंबर", border: OutlineInputBorder())),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[900], minimumSize: const Size(double.infinity, 50)),
              onPressed: _saveData,
              child: const Text("डाटा सबमिट करें", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
