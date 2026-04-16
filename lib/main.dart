import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint("Firebase connection skipped");
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
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const LandingPage(),
    );
  }
}

// --- मुख्य स्क्रीन ---
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("विकास पासोरिया ऑफिशियल"),
        backgroundColor: Colors.orange[900],
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange[200]!, Colors.white],
            begin: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.orange,
              child: Icon(Icons.mic_external_on, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text("🚩 जय श्री राम 🚩", 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red)),
            const Text("लोकगायक विकास पासोरिया", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage())),
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text("मेंबर रजिस्ट्रेशन", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- रजिस्ट्रेशन पेज ---
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
  bool _isLoading = false;

  void _saveData() async {
    if (_name.text.isEmpty || _phone.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("नाम और नंबर ज़रूरी है!")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // यह कोड दोनों कलेक्शन (menus और members) में डेटा भेजने की कोशिश करेगा
      Map<String, dynamic> userData = {
        'name': _name.text,
        'village': _village.text,
        'work': _work.text,
        'phone': _phone.text,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // आपके Firebase के अनुसार 'menus' में भेजना
      await FirebaseFirestore.instance.collection('menus').add(userData);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("सफल!"),
            content: const Text("आपकी जानकारी सेव हो गई है। जय श्री राम!"),
            actions: [TextButton(onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }, child: const Text("ठीक है"))],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("एरर: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("अपनी जानकारी भरें"), backgroundColor: Colors.orange[800]),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextField(controller: _name, decoration: const InputDecoration(labelText: "नाम", prefixIcon: Icon(Icons.person))),
                    const SizedBox(height: 10),
                    TextField(controller: _village, decoration: const InputDecoration(labelText: "गाँव", prefixIcon: Icon(Icons.home))),
                    const SizedBox(height: 10),
                    TextField(controller: _work, decoration: const InputDecoration(labelText: "व्यवसाय", prefixIcon: Icon(Icons.work))),
                    const SizedBox(height: 10),
                    TextField(controller: _phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "मोबाइल नंबर", prefixIcon: Icon(Icons.phone))),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _saveData,
                      child: const Text("सबमिट करें", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
