const express = require('express');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const mysql = require('mysql');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 4000;
const SECRET_KEY = 'my-secret-key';

app.use(bodyParser.json());
app.use(cors());

const conn = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "katisha_system_db"
});

conn.connect(err => {
    if (err) {
        console.error("Error connecting to the database", err)
        return;
    }
    console.log("Connected")
});

app.post('/login', (req, res) => {
    const { email, password } = req.body;
    const sql = "SELECT * FROM admins WHERE email = ?";

    conn.query(sql, [email], (err, results) => {
        if (err) {
            console.error("Error fetching user:", err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }

        if (results.length === 0) {
            return res.status(401).json({ error: 'User not found' });
        }

        const user = results[0];

        bcrypt.compare(password, user.passwordHash, (err, result) => {
            if (err || !result) {
                return res.status(401).json({ error: 'Password incorrect' });
            }

            const token = jwt.sign({ id: user.id, email: user.email }, SECRET_KEY);
            res.json({ token });
        });
    });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
