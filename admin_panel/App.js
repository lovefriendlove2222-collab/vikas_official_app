// ... पुराने इम्पोर्ट्स ...
const [newService, setNewService] = useState("");

const addService = async () => {
  if (newService === "") return;
  await addDoc(collection(db, "menus"), {
    title: newService,
    type: "general", // या "donation"
    icon: "default_icon"
  });
  setNewService("");
  alert("नई योजना सफलतापूर्वक जोड़ी गई!");
};

// UI में ये जोड़ें
return (
  <div>
    <h2>एडमिन कंट्रोल - विकास पासोरिया</h2>
    <div style={{border: '1px solid #ccc', padding: '10px', marginBottom: '20px'}}>
      <h3>नई सेवा/योजना जोड़ें</h3>
      <input 
        value={newService} 
        onChange={(e) => setNewService(e.target.value)} 
        placeholder="योजना का नाम (जैसे: पेंशन योजना)"
      />
      <button onClick={addService}>App (Live) में जोड़ें</button>
    </div>
    {/* ... यूजर अप्रूवल लिस्ट ... */}
  </div>
);
