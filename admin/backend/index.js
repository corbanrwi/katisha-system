const express = require('express')
const bodyParser = require('body-parser')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')

const app = express();
const PORT = process.env.PORT || 4000;
const SECRET_KEY = 'my-secret-key';

app.use(bodyParser.json());

const users = [
    {
        id: 1,
        email: 'john@gmail.com',
        name:'Jogn Doe',
        passwordHash: '$2b$10$Nalv4t8ixK1M4ti7O6H7Qet/hdF3.Lm6sjbMeIz4bB3b4m7KP8RVO',
        agency: 'Ritco travels'
    },
    {
        id: 2,
        email: 'jane@gmail.com',
        name: 'Jane Doe',
        passwordHash: '$2b$10$Nalv4t8ixK1M4ti7O6H7Qet/hdF3.Lm6sjbMeIz4bB3b4m7KP8RVO',
        agency: 'Kigali Coach'
    }
]

app.post('/login',(req,res)=>{
    const { email, password } = req.body;
    const user = users.find(user => user.email === email);
    if(!user){
        return res.status(404).json({Error:"User not found"})
    }
    bcrypt.compare(password, user.passwordHash, (err, result) => {
        if(err || !result) {
            return res.status(401).json({Error:"Invalid username or password"});
        }
        const token = jwt.sign({id: user.id, name: user.name, agency: user.agency}, SECRET_KEY);
        res.json({ token });
    })
})


app.get('/login', (req, res) => {
    res.status(405).send('Method Not Yet Needed');
});




app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
