const [applications, setApplications] = useState([]);

useEffect(() => {
  // आवेदन (Applications) लोड करें
  getDocs(collection(db, "applications")).then((snap) => {
    setApplications(snap.docs.map(d => ({ id: d.id, ...d.data() })));
  });
}, []);

// UI में नीचे जोड़ें
<div style={{marginTop: '40px'}}>
  <h3>प्राप्त आवेदन (Applications)</h3>
  {applications.map(app => (
    <div key={app.id} style={{border: '1px solid gray', margin: '10px', padding: '10px'}}>
      <p><b>योजना:</b> {app.service_name}</p>
      <p><b>यूजर ID:</b> {app.user_id}</p>
      <p><b>विवरण:</b> {app.details}</p>
      <p><b>स्टेटस:</b> {app.status}</p>
    </div>
  ))}
</div>
