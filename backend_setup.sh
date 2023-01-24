#!/bin/bash

echo "Creating Angular Backend Environment"
sudo mkdir MEAN/backend
cd MEAN/backend
sudo npm init -y
sudo npm install --save body-parser cors express mongoose path

echo "Create server.js file"
sudo echo "
const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();

var corsOptions = {
  origin: 'http://localhost:8081'
};

app.use(cors(corsOptions));

// parse requests of content-type - application/json
app.use(express.json());

// parse requests of content-type - application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));

// simple route
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to MEAN CRUD application.' });
});

// import tutorials routes
const tutorials = require(path.join(__dirname, 'controllers', 'tutorial.controller.js'));

// setup tutorials routes
var router = require('express').Router();

// Create a new Tutorial
router.post('/', tutorials.create);

// Retrieve all Tutorials
router.get('/', tutorials.findAll);

// Retrieve all published Tutorials
router.get('/published', tutorials.findAllPublished);

// Retrieve a single Tutorial with id
router.get('/:id', tutorials.findOne);

// Update a Tutorial with id
router.put('/:id', tutorials.update);

// Delete a Tutorial with id
router.delete('/:id', tutorials.delete);

// Delete all Tutorials
router.delete('/', tutorials.deleteAll);

app.use('/api/tutorials', router);


// Connect to DB MEANCRUD
const db = require('./models');
db.mongoose
  .connect(db.url, {
    useNewUrlParser: true,
    useUnifiedTopology: true
  })
  .then(() => {
    console.log('Connected to the database!');
  })
  .catch(err => {
    console.log('Cannot connect to the database!', err);
    process.exit();
  });

// set port, listen for requests
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});

echo "Create routes/tutorial.routes.js file"
sudo mkdir routes
sudo echo "
const path = require('path');

module.exports = app => {
  const tutorials = require(path.join(__dirname, 'controllers', 'tutorial.controller.js'));

  var router = require('express').Router();

  // Create a new Tutorial
  router.post('/', tutorials.create);

  // Retrieve all Tutorials
  router.get('/', tutorials.findAll);

  // Retrieve all published Tutorials
  router.get('/published', tutorials.findAllPublished);

  // Retrieve a single Tutorial with id
  router.get('/:id', tutorials.findOne);

  // Update a Tutorial with id
  router.put('/:id', tutorials.update);

  // Delete a Tutorial with id
  router.delete('/:id', tutorials.delete);

  // Delete all Tutorials
  router.delete('/', tutorials.deleteAll);

  app.use('/api/tutorials', router);

}; > routes/tutorial.routes.js

echo "Create models/index.js file"
sudo mkdir models
sudo echo "

