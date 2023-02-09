const express = require("express");
const mongoose = require("mongoose");
const Movie = require("./models/movie");
const PORT = 3000;
const URL = "mongodb://localhost:27017/movies";
const app = express();
mongoose.set("strictQuery", true);

mongoose
  .connect(URL)
  .then(() => {
    console.log("Connect successful");
  })
  .catch((err) => {
    console.log(`Error connecting to MongoDB ${err}`);
  });
app.listen(PORT, (error) => {
  error ? console.log(error) : console.log(`Listening on ${PORT}`);
});
app.use(express.json());
let db;

const handleError = (res, error) => {
  res.status(500).json({ error });
};

app.get("/movies", (req, res) => {
  Movie.find()
    .then((movies) => {
      res.status(200).json(movies);
    })
    .catch(() => {
      handleError(res, "Something goes wrong...");
    });
});

app.get("/movies/:id", (req, res) => {
  Movie.findById(req.params.id)
    .then((movie) => {
      res.status(200).json(movie);
    })
    .catch(() => {
      handleError(res, "Something goes wrong...");
    });
});

app.delete("/movies/:id", (req, res) => {
  Movie.findByIdAndDelete(req.params.id)
    .then((result) => {
      res.status(200).json(result);
    })
    .catch(() => {
      handleError(res, "Something goes wrong...");
    });
});

app.post("/movies", (req, res) => {
  const movie = new Movie(req.body);
  movie
    .save()
    .then((result) => {
      res.status(201).json(result);
    })
    .catch(() => {
      handleError(res, "Something goes wrong...");
    });
});

app.patch("/movies/:id", (req, res) => {
  Movie
  .findByIdAndUpdate(req.params.id, req.body)
    .then((result) => {
      res.status(200).json(result);
    })
    .catch(() => {
      handleError(res, "Error updating");
    });
});
