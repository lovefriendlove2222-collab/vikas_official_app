// ... login function के अंदर ...
if (doc.exists) {
  if (doc['role'] == 'admin') {
    // अगर यूजर एडमिन है तो एडमिन पेज पर भेजें
    Navigator.push(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
  } else if (doc['approved']) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen(phone.text)));
  } else {
    show(context, "आपका अकाउंट अभी अप्रूव नहीं हुआ है।");
  }
}
