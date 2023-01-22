#!/bin/bash

echo "Creating Angular Backend Environment"
sudo mkdir MEAN/backend
cd MEAN/backend
sudo npm init -y
sudo npm install --save body-parser cors express mongoose

echo "Create server.js file"
sudo echo "
const express = require('express')
const path = require('path')
const mongoose = require('mongoose')
const cors = require('cors')
const bodyParser = require('body-parser')
// Connecting with mongo db
mongoose
  .connect('mongodb://localhost:27017/mydatabase')
  .then((x) => {
    console.log(`Connected to Mongo! Database name: \\"${x.connections[0].name}\\"`)
  })
  .catch((err) => {
    console.error('Error connecting to mongo', err.reason)
  })
// Setting up port with express js
const employeeRoute = require('../backend/routes/employee.route')
const app = express()
app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: false,
  }),
)
app.use(cors())
app.use(express.static(path.join(__dirname, 'dist/MEAN')))
app.use('/', express.static(path.join(__dirname, 'dist/MEAN')))
app.use('/api', employeeRoute)
// Create port
const port = process.env.PORT || 4000
const server = app.listen(port, () => {
  console.log('Connected to port ' + port)
})
// Find 404 and hand over to error handler
app.use((req, res, next) => {
  next(createError(404))
})
// error handler
app.use(function (err, req, res, next) {
  console.error(err.message) // Log error message in our server's console
  if (!err.statusCode) err.statusCode = 500 // If err has no specified error code, set error code to 'Internal Server Error (500)'    
  res.status(err.statusCode).send(err.message) // All HTTP requests must have a response, so let's send back an error with its status code and message
})" > server.js

sudo sed -i 's/index.js/server.js/' package.json

echo "Create DB models"
sudo mkdir models
sudo echo "
const mongoose = require('mongoose');
const Schema = mongoose.Schema;
// Define collection and schema
let Employee = new Schema({
   name: {
      type: String
   },
   email: {
      type: String
   },
   designation: {
      type: String
   },
   phoneNumber: {
      type: Number
   }
}, {
   collection: 'employees'
})
module.exports = mongoose.model('Employee', Employee)" > models/Employee.js

echo "Create API routes"
sudo mkdir routes
sudo echo "
const express = require('express');
const app = express();
const employeeRoute = express.Router();
// Employee model
let Employee = require('../models/Employee');
// Add Employee
employeeRoute.route('/create').post((req, res, next) => {
  Employee.create(req.body, (error, data) => {
    if (error) {
      return next(error)
    } else {
      res.json(data)
    }
  })
});
// Get All Employees
employeeRoute.route('/').get((req, res) => {
  Employee.find((error, data) => {
    if (error) {
      return next(error)
    } else {
      res.json(data)
    }
  })
})
// Get single employee
employeeRoute.route('/read/:id').get((req, res) => {
  Employee.findById(req.params.id, (error, data) => {
    if (error) {
      return next(error)
    } else {
      res.json(data)
    }
  })
})

// Update employee
employeeRoute.route('/update/:id').put((req, res, next) => {
  Employee.findByIdAndUpdate(req.params.id, {
    \$set: req.body
  }, (error, data) => {
    if (error) {
      return next(error);
      console.log(error)
    } else {
      res.json(data)
      console.log('Data updated successfully')
    }
  })
})
// Delete employee
employeeRoute.route('/delete/:id').delete((req, res, next) => {
  Employee.findOneAndRemove(req.params.id, (error, data) => {
    if (error) {
      return next(error);
    } else {
      res.status(200).json({
        msg: data
      })
    }
  })
})
module.exports = employeeRoute;" > routes/employee.route.js

echo "Start Angular Backend Environment"
sudo node server.js
