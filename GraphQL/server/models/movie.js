const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const movieSchema = new Schema({
    name: String,
    genre: String,
    directorId: String,
});

model.exports = mongoose.model('Movie', movieSchema)