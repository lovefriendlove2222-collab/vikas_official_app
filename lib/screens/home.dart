// ... imports ...

class HomeScreen extends StatelessWidget {
  final String userId;
  HomeScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("विकास पासोरिया - सेवाएं")),
      body: StreamBuilder(
        // 'menus' कलेक्शन से डेटा लाइव आएगा
        stream: FirebaseFirestore.instance.collection('menus').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 कॉलम में योजनाएं दिखेंगी
              childAspectRatio: 1.0,
            ),
            itemCount: snap.data!.docs.length,
            itemBuilder: (context, index) {
              var service = snap.data!.docs[index];
              return Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    // यहाँ सर्विस के टाइप के हिसाब से पेज खुलेगा
                    _navigateToService(context, service['type'], service['title']);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.Category, size: 40, color: Colors.orange), // आप इमेज भी जोड़ सकते हैं
                      SizedBox(height: 10),
                      Text(service['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToService(context, type, title) {
    // अगर सर्विस 'donation' है तो डोनेशन पेज, वरना जनरल फॉर्म
    if (type == "donation") {
      Navigator.push(context, MaterialPageRoute(builder: (_) => DonationScreen(userId)));
    } else {
      // भविष्य की 100+ योजनाओं के लिए एक कॉमन फॉर्म पेज
      Navigator.push(context, MaterialPageRoute(builder: (_) => GenericServiceForm(title)));
    }
  }
}
