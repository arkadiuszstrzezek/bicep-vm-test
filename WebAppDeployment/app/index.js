const express = require('express');
const sql = require('mssql');
const app = express();
const port = process.env.PORT || 3000;

// Azure SQL connection configuration
const config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_NAME,
  options: {
    encrypt: true,
    trustServerCertificate: false,
  },
};

// Middleware
app.use(express.urlencoded({ extended: true }));
app.use(express.static('views'));

// Route to display voting page
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/views/index.html');
});

// Route to handle votes
app.post('/vote', async (req, res) => {
  const vote = req.body.vote;
  try {
    const pool = await sql.connect(config);
    await pool.request().query(`INSERT INTO Votes (choice) VALUES ('${vote}')`);
    res.send('Thank you for voting!');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error saving your vote.');
  }
});

// Start server
app.listen(port, () => {
  console.log(`App running on http://localhost:${port}`);
});