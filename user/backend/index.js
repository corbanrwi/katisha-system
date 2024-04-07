const express = require('express')
const bodyParser = require('body-parser')
const mysql = require('mysql')
const cors = require('cors')
const path = require('path')

const app = express();
const PORT = process.env.PORT || 4000;

const conn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'katisha_system_db'
});

conn.connect(err => {
    if(err){
    console.error('Error connecting to mysql');
    return;
    }
    console.log('Connected')
})
app.use(cors());
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, '../frontend')));

app.get('/locations',(req, res) => {
    const query = req.query.q;
    const sql = "SELECT * FROM locations WHERE location_name LIKE ?";
    conn.query(sql, [`%${query}%`], (err,result) => {
        if(err) {
            console.error('Error executing query:', err)
            res.status(500).json({error: "Internal Server Error"});
            return;
        }
        res.json(result);


    })

});
app.post('/search', (req,res)=>{
    const {from, to} = req.body;
    const currentTime = new Date();
    const minDeparture = new Date(currentTime.getTime() + 5 * 60000);
    const sql = `
    SELECT b.*, d.DestinationName
    FROM buses b
    INNER JOIN destinations d ON b.DestinationID = d.DestinationID
    WHERE d.DestinationName = ? AND b.DeptTime >= ? AND b.AvailableSeats > 0
    `;
    conn.query(sql, [`${from}-${to}`, minDeparture], (err, results) => {
       if(err) {
           console.error("Error:", err)
           return res.status(500).json({error: "Internal Server Error"})
       }
       res.json({ from, to, data: results });
    });
});
app.get('/bus-details', (req, res) => {
    res.sendFile(path.join(__dirname, '../frontend/bus-details.html'));
});

app.listen(PORT, () => {
    console.log(`Server listening on port  http://localhost${PORT}`);
})