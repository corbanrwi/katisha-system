const express = require('express')
const bodyParser = require('body-parser')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const mysql = require('mysql')

const app = express();
const PORT = process.env.PORT || 4000;
const SECRET_KEY = 'my-secret-key';

app.use(bodyParser.json());

const conn = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "katisha_system_db"
})
conn.connect(err=>{
    if (err){
    console.error("Error connecting to the database", err)
    return;
    }
    console.log("Connected")
});

app.post('/', (req,res) => {
    const { email, password } = req.body;
    const sql = "SELECT * FROM admins WHERE email = ?"
    conn.query(sql, [email], (err, results) => {
        if(err) {
            console.error("Error fetching user:", err)
        }
        if(results.length === 0) {
            return res.status(500).json({ error: 'User not found'})
        }
        const user = results[0];

        bcrypt.compare(password, user.passwordHash, (err, result) => {
            if(err || !result) {
                return res.status(401).json({error: "Password incorrect"})
            }
            const agencyQuery = "SELECT * FROM agencies WHERE AgencyID = ?"
            conn.query(agencyQuery, [user.agencyid], (err, agencyResults) => {
                if(err) {
                    console.error("Error fetching agency", err)
                    return res.status(500).json({ error: "Internal Server Error"});

                }
                if(agencyResults.length === 0) {
                    return res.status(500).json({error: "Agency Not found"})
                }

                const token = jwt.sign({id: user.id, name: user.name, agency: agencyResults[0].AgencyName}, SECRET_KEY)
                res.json({ token })
            })
        })
    })
})




app.get('/login', (req, res) => {
    res.status(405).send('Method Not Yet Needed');
});




app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
