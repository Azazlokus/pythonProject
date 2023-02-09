const express = require('express');
const createPath = require('./helpers/createPath');
const routes = require('./routes/routes');
const app = express();

const PORT = 3000;

app.get('/', (req, res) => {
    return res.render(createPath('index'));
});

app.listen(PORT, (error) => {
    error ? console.log(error) : console.log(`Listening ${PORT}`)
});
