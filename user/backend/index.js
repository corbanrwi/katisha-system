const express = require('express')
const bodyParser = require('body-parser')
const mysql = require('mysql')
const cors = require('cors')
const path = require('path')
const qr = require('qrcode')

const app = express();
const PORT = process.env.PORT || 4050;

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
app.use(express.static(path.join(__dirname, '../frontend/')));

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../frontend/index.html'));
});

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

app.get('/agencies/:id', (req,res) => {
    const agencyid = req.params.id
    const sql = 'SELECT * FROM agencies WHERE AgencyID =?';
    conn.query(sql, [agencyid], (err, results) => {
        if(err) {
            console.error("Error executing query:",err)
            res.status(500).json({error:"Internal Server Error"})
            return;
        }
        const agency = results[0];
        res.json(agency);
    })
})
app.post('/payemnt', (req, res)=> {
    const {amount, busname, destinationName, deptTime, agencyName, name, email, phone} = req.body;
    const transactionID = generateTransactionID();
    const notification = {
        transactionID,
        message: 'Payment notification sent successfully',
        status: 'pending'
    }
    const ticketData = {
        transactionID,
        busname,
        destinationName,
        deptTime,
        agencyName,
        name,
        email,
        phone
    }

    const sql = 'INSERT INTO TICKETS SET ?';
    conn.query(sql, [ticketData], (err, results) => {
        if(err) {
            console.error("Error executing query:",err)
            res.status(500).json({error:"Failed to process payment data. Please try again."})
            return;
        } else {
            console.log("Ticket data inserted into database", results);
            res.json({notification});
        }
    })
   })

   app.get('/comfim/:transactionID', (req, res) => {
    const transactionID = req.params;
       const sql = 'SELECT * FROM TICKETS WHERE transactionID =?';
       conn.query(sql, [transactionID], (err, results) => {
        if(err) {
            console.error("Error executing query:", err)
            res.status(500).json({error: "Failed to confirm payment. Please try again."})
            return;
        }
        if(results.length === 0) {
            res.status(404).json({error: "Transaction not found"})
        }
        const ticket = results[0];
        const qrcodeData = {
            ticketID: ticket.ticketID,
            transactionID: ticket.transactionID,
            busname: ticket.busname,
            destinationName: ticket.destinationName,
            deptTime: ticket.deptTime,
            agencyName: ticket.agencyName,
            name: ticket.name,
            email: ticket.email,
            phone: ticket
        }
        qr.toDataURL(qrcodeData, (err, qrCode) => {
            if(err){
                console.error("Error Gnerating QR code", err);
                res.status(500).json({error: "Failed to generate QR code. Please try again."})
            } else {
                console.log("QR code generated successfully");
            }
            const sql = 'UPDATE TICKETS SET qrCode =? WHERE transactionID =?';
            conn.query(sql, [qrCode, transactionID], (err, results) => {
                if(err) {
                    console.error("Error executing query:", err)
                    res.status(500).json({error: "Failed to generate QR code. Please try again."})
                    return;
                }else {
                    console.log("QR code updated successfully", results);
                    res.send("Payment confirmed successfully");
                }
            })
        })
       })
   });

   function generateTransactionID() {
    const timestamp = new Date().getTime().toString();
    const randomString = Math.random().toString(36).substr(2, 6);
    const processId = process.pid.toString(36);
    const counter = (Math.floor(Math.random() * 10000).toString(36).padStart(4, '0'));

    return timestamp + randomString + processId + counter;
   }

app.listen(PORT, () => {
    console.log(`Server listening on port  http://localhost ${PORT}`);
})