#!/bin/bash

echo "Creating Angular Backend Environment"
sudo mkdir MEAN/backend
cd MEAN/backend
sudo npm init -y
sudo npm install --save body-parser cors express mongoose

echo "Create server.js file"
sudo echo "
const express = require(\'express\')
const path = require(\'path\')
const mongoose = require(\'mongoose\')
const cors = require(\'cors\')
const bodyParser = require(\'body-parser\')
// Connecting with mongo db
mongoose
  .connect(\'mongodb://localhost:27017/mydatabase\')
  .then((x) => {
    console.log(\`Connected to Mongo! Database name: \"\${x.connections[0].name}\"\`)
  })
  .catch((err) => {
    console.error(\'Error connecting to mongo\', err.reason)
  })
// Setting up port with express js
const employeeRoute = require(\'../backend/routes/employee.route\')
const app = express()
app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: false,
  }),
)
app.use(cors())
app.use(express.static(path.join(__dirname, \'dist/MEAN\')))
app.use(\'/\', express.static(path.join(__dirname, \'dist/MEAN\')))
app.use(\'/api\', employeeRoute)
// Create port
const port = process.env.PORT || 4000
const server = app.listen(port, () => {
  console.log(\'Connected to port \' + port)
})
// Find 404 and hand over to error handler
app.use((req, res, next) => {
  next(createError(404))
})
// error handler
app.use(function (err, req, res, next) {
  console.error(err.message) // Log error message in our server's console
  if (!err.statusCode) err.statusCode = 500 // If err has no specified error code, set error code to \'Internal Server Error (500)\'    
  res.status(err.statusCode).send(err.message) // All HTTP requests must have a response, so let's send back an error with its status 
code and message
})" > server.js

sudo sed -i 's/index.js/server.js/' package.json


