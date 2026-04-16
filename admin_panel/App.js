import { useState, useEffect } from "react";
import { db } from "./firebase";
import { collection, addDoc, getDocs, updateDoc, doc } from "firebase/firestore";

export default function App() {
  const [serviceName, setServiceName] = useState("");
  const [description, setDescription] = useState("");
  const [users, setUsers] = useState([]);

  const addNewService = async () => {
    if (serviceName === "") return alert("योजना का नाम लिखें!");
    await addDoc(collection(db, "menus"), {
      title: serviceName,
      desc: description,
      type: "info"
    });
    alert("योजना लाइव हो गई, विकास भाई!");
    setServiceName(""); setDescription("");
  };

  return (
    <div style={{ padding: '30px', fontFamily: 'Arial' }}>
      <h1>विकास पासोरिया एडमिन कंट्रोल</h1>
      <div style={{ background: '#f9f9f9', padding: '20px', borderRadius: '10px' }}>
        <h3>नई योजना जोड़ें</h3>
        <input value={serviceName} onChange={(e) => setServiceName(e.target.value)} placeholder="योजना का नाम" style={{display:'block', marginBottom:'10px', width:'100%'}} />
        <textarea value={description} onChange={(e) => setDescription(e.target.value)} placeholder="योजना की पूरी जानकारी" style={{display:'block', marginBottom:'10px', width:'100%'}} />
        <button onClick={addNewService} style={{ background: 'orange', padding: '10px 20px', border: 'none', cursor: 'pointer' }}>App में लाइव करें 🚀</button>
      </div>
    </div>
  );
}
