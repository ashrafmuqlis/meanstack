# meanstack
Notes on MEAN (MongoDB, Express, Angular and Node JS stack. How to's, etc.) Development Framework

## Setup Application Scaffolding (MongoDB, Node JS, Angular JS) Terminal #1
```
#!/bin/bash

echo "Installing MongoDB 6"
sudo wget -q -O - https://www.mongodb.org/static/pgp/server-6.0.pub | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb.gpg     
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod.service
sudo systemctl status mongod
sudo systemctl enable mongod

echo "Installing Node JS 19"
sudo curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

echo "Setting up Angular MEAN Frontend"
sudo npm install @angular/cli -g
sudo ng new MEAN
cd MEAN/ 
sudo npm install bootstrap
cd src/app/
sudo ng g class models/tutorial --type=model
sudo ng g c components/add-tutorial
sudo ng g c components/tutorial-details
sudo ng g c components/tutorials-list
sudo ng g s services/tutorial
```
## Load Application Files Terminal #2
```
#!/bin/bash

echo "Loading Application Files - app.module.ts"
sudo echo "
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';  

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { AddTutorialComponent } from './components/add-tutorial/add-tutorial.component';
import { TutorialDetailsComponent } from './components/tutorial-details/tutorial-details.component';
import { TutorialsListComponent } from './components/tutorials-list/tutorials-list.component';

@NgModule({
  declarations: [
    AppComponent,
    AddTutorialComponent,
    TutorialDetailsComponent,
    TutorialsListComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpClientModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }" > app.module.ts
sudo mv app.module.ts MEAN/src/app/app.module.ts

echo "Loading Application Files - app-routing.module.ts"
sudo echo "
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TutorialsListComponent } from './components/tutorials-list/tutorials-list.component';
import { TutorialDetailsComponent } from './components/tutorial-details/tutorial-details.component';
import { AddTutorialComponent } from './components/add-tutorial/add-tutorial.component';

const routes: Routes = [
  { path: '', redirectTo: 'tutorials', pathMatch: 'full' },
  { path: 'tutorials', component: TutorialsListComponent },
  { path: 'tutorials/:id', component: TutorialDetailsComponent },
  { path: 'add', component: AddTutorialComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }" > app-routing.module.ts
sudo mv app-routing.module.ts MEAN/src/app/app-routing.module.ts

echo "Loading Application Files - styles.css"
sudo echo "
@import \"~bootstrap/dist/css/bootstrap.css\";" > styles.css
sudo mv styles.css MEAN/src/styles.css

echo "Loading Application Files - app.component.html"
sudo echo "
<div>
  <nav class=\"navbar navbar-expand navbar-dark bg-dark\">
    <a href=\"#\" class=\"navbar-brand\">MEAN-CRUD</a>
    <div class=\"navbar-nav mr-auto\">
      <li class=\"nav-item\">
        <a routerLink=\"tutorials\" class=\"nav-link\">Tutorials</a>
      </li>
      <li class=\"nav-item\">
        <a routerLink=\"add\" class=\"nav-link\">Add</a>
      </li>
    </div>
  </nav>

  <div class=\"container mt-3\">
    <router-outlet></router-outlet>
  </div>
</div>" > app.component.html
sudo mv app.component.html MEAN/src/app/app.component.html

echo "Loading Application Files - tutorial.model.ts"
sudo echo "
export class Tutorial {
  id?: any;
  title?: string;
  description?: string;
  published?: boolean;
}" > tutorial.model.ts
sudo mv tutorial.model.ts MEAN/src/app/models/tutorial.model.ts

echo "Loading Application Files - tutorial.service.ts"
sudo echo "
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Tutorial } from '../models/tutorial.model';

const baseUrl = 'http://localhost:8080/api/tutorials';

@Injectable({
  providedIn: 'root'
})
export class TutorialService {

  constructor(private http: HttpClient) { }

  getAll(): Observable<Tutorial[]> {
    return this.http.get<Tutorial[]>(baseUrl);
  }

  get(id: any): Observable<Tutorial> {
    return this.http.get<Tutorial>(\`\${baseUrl}/\${id}\`);
  }

  create(data: any): Observable<any> {
    return this.http.post(baseUrl, data);
  }

  update(id: any, data: any): Observable<any> {
    return this.http.put(\`\${baseUrl}/\${id}\`, data);
  }

  delete(id: any): Observable<any> {
    return this.http.delete(\`\${baseUrl}/\${id}\`);
  }

  deleteAll(): Observable<any> {
    return this.http.delete(baseUrl);
  }

  findByTitle(title: any): Observable<Tutorial[]> {
    return this.http.get<Tutorial[]>(\`\${baseUrl}?title=\${title}\`);
  }
}" > tutorial.service.ts
sudo mv tutorial.service.ts MEAN/src/app/services/tutorial.service.ts

echo "Loading Application Files - tutorial-details.component.ts"
sudo echo "
import { Component, Input, OnInit } from '@angular/core';
import { TutorialService } from 'src/app/services/tutorial.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Tutorial } from 'src/app/models/tutorial.model';

@Component({
  selector: 'app-tutorial-details',
  templateUrl: './tutorial-details.component.html',
  styleUrls: ['./tutorial-details.component.css']
})
export class TutorialDetailsComponent implements OnInit {

  @Input() viewMode = false;

  @Input() currentTutorial: Tutorial = {
    title: '',
    description: '',
    published: false
  };

  message = '';

  constructor(
    private tutorialService: TutorialService,
    private route: ActivatedRoute,
    private router: Router) { }

  ngOnInit(): void {
    if (!this.viewMode) {
      this.message = '';
      this.getTutorial(this.route.snapshot.params[\"id\"]);
    }
  }

  getTutorial(id: string): void {
    this.tutorialService.get(id)
      .subscribe({
        next: (data) => {
          this.currentTutorial = data;
          console.log(data);
        },
        error: (e) => console.error(e)
      });
  }

  updatePublished(status: boolean): void {
    const data = {
      title: this.currentTutorial.title,
      description: this.currentTutorial.description,
      published: status
    };

    this.message = '';

    this.tutorialService.update(this.currentTutorial.id, data)
      .subscribe({
        next: (res) => {
          console.log(res);
          this.currentTutorial.published = status;
          this.message = res.message ? res.message : 'The status was updated successfully!';
        },
        error: (e) => console.error(e)
      });
  }

  updateTutorial(): void {
    this.message = '';

    this.tutorialService.update(this.currentTutorial.id, this.currentTutorial)
      .subscribe({
        next: (res) => {
          console.log(res);
          this.message = res.message ? res.message : 'This tutorial was updated successfully!';
        },
        error: (e) => console.error(e)
      });
  }

  deleteTutorial(): void {
    this.tutorialService.delete(this.currentTutorial.id)
      .subscribe({
        next: (res) => {
          console.log(res);
          this.router.navigate(['/tutorials']);
        },
        error: (e) => console.error(e)
      });
  }

}" > tutorial-details.component.ts
sudo mv tutorial-details.component.ts MEAN/src/app/components/tutorial-details/tutorial-details.component.ts

echo "Loading Application Files - tutorial-details.component.html"
sudo echo "
<div *ngIf=\"viewMode; else editable\">
  <div *ngIf=\"currentTutorial.id\">
    <h4>Tutorial</h4>
    <div>
      <label><strong>Title:</strong></label> {{ currentTutorial.title }}
    </div>
    <div>
      <label><strong>Description:</strong></label>
      {{ currentTutorial.description }}
    </div>
    <div>
      <label><strong>Status:</strong></label>
      {{ currentTutorial.published ? \"Published\" : \"Pending\" }}
    </div>

    <a
      class=\"badge badge-warning\"
      routerLink=\"/tutorials/{{ currentTutorial.id }}\"
    >
      Edit
    </a>
  </div>

  <div *ngIf=\"!currentTutorial\">
    <br />
    <p>Please click on a Tutorial...</p>
  </div>
</div>

<ng-template #editable>
  <div *ngIf=\"currentTutorial.id\" class=\"edit-form\">
    <h4>Tutorial</h4>
    <form>
      <div class=\"form-group\">
        <label for=\"title\">Title</label>
        <input
          type=\"text\"
          class=\"form-control\"
          id=\"title\"
          [(ngModel)]=\"currentTutorial.title\"
          name=\"title\"
        />
      </div>
      <div class=\"form-group\">
        <label for=\"description\">Description</label>
        <input
          type=\"text\"
          class=\"form-control\"
          id=\"description\"
          [(ngModel)]=\"currentTutorial.description\"
          name=\"description\"
        />
      </div>

      <div class=\"form-group\">
        <label><strong>Status:</strong></label>
        {{ currentTutorial.published ? \"Published\" : \"Pending\" }}
      </div>
    </form>

    <button
      class=\"badge badge-primary mr-2\"
      *ngIf=\"currentTutorial.published\"
      (click)=\"updatePublished(false)\"
    >
      UnPublish
    </button>
    <button
      *ngIf=\"!currentTutorial.published\"
      class=\"badge badge-primary mr-2\"
      (click)=\"updatePublished(true)\"
    >
      Publish
    </button>

    <button class=\"badge badge-danger mr-2\" (click)=\"deleteTutorial()\">
      Delete
    </button>

    <button
      type=\"submit\"
      class=\"badge badge-success mb-2\"
      (click)=\"updateTutorial()\"
    >
      Update
    </button>
    <p>{{ message }}</p>
  </div>

  <div *ngIf=\"!currentTutorial.id\">
    <br />
    <p>Cannot access this Tutorial...</p>
  </div>
</ng-template>" > tutorial-details.component.html
sudo mv tutorial-details.component.html MEAN/src/app/components/tutorial-details/tutorial-details.component.html

echo "Loading Application Files - tutorial-details.component.css"
sudo echo "
.edit-form {
  max-width: 400px;
  margin: auto;
}" > tutorial-details.component.css
sudo mv tutorial-details.component.css MEAN/src/app/components/tutorial-details/tutorial-details.component.css

echo "Loading Application Files - tutorials-list.component.ts"
sudo echo "
import { Component, OnInit } from '@angular/core';
import { Tutorial } from 'src/app/models/tutorial.model';
import { TutorialService } from 'src/app/services/tutorial.service';

@Component({
  selector: 'app-tutorials-list',
  templateUrl: './tutorials-list.component.html',
  styleUrls: ['./tutorials-list.component.css']
})
export class TutorialsListComponent implements OnInit {

  tutorials?: Tutorial[];
  currentTutorial: Tutorial = {};
  currentIndex = -1;
  title = '';

  constructor(private tutorialService: TutorialService) { }

  ngOnInit(): void {
    this.retrieveTutorials();
  }

  retrieveTutorials(): void {
    this.tutorialService.getAll()
      .subscribe({
        next: (data) => {
          this.tutorials = data;
          console.log(data);
        },
        error: (e) => console.error(e)
      });
  }

  refreshList(): void {
    this.retrieveTutorials();
    this.currentTutorial = {};
    this.currentIndex = -1;
  }

  setActiveTutorial(tutorial: Tutorial, index: number): void {
    this.currentTutorial = tutorial;
    this.currentIndex = index;
  }

  removeAllTutorials(): void {
    this.tutorialService.deleteAll()
      .subscribe({
        next: (res) => {
          console.log(res);
          this.refreshList();
        },
        error: (e) => console.error(e)
      });
  }

  searchTitle(): void {
    this.currentTutorial = {};
    this.currentIndex = -1;

    this.tutorialService.findByTitle(this.title)
      .subscribe({
        next: (data) => {
          this.tutorials = data;
          console.log(data);
        },
        error: (e) => console.error(e)
      });
  }

}" > tutorials-list.component.ts
sudo mv tutorials-list.component.ts MEAN/src/app/components/tutorials-list/tutorials-list.component.ts

echo "Loading Application Files - tutorials-list.component.html"
sudo echo "
<div class=\"list row\">
  <div class=\"col-md-8\">
    <div class=\"input-group mb-3\">
      <input
        type=\"text\"
        class=\"form-control\"
        placeholder=\"Search by title\"
        [(ngModel)]=\"title\"
      />
      <div class=\"input-group-append\">
        <button
          class=\"btn btn-outline-secondary\"
          type=\"button\"
          (click)=\"searchTitle()\"
        >
          Search
        </button>
      </div>
    </div>
  </div>
  <div class=\"col-md-6\">
    <h4>Tutorials List</h4>
    <ul class=\"list-group\">
      <li
        class=\"list-group-item\"
        *ngFor=\"let tutorial of tutorials; let i = index\"
        [class.active]=\"i == currentIndex\"
        (click)=\"setActiveTutorial(tutorial, i)\"
      >
        {{ tutorial.title }}
      </li>
    </ul>

    <button class=\"m-3 btn btn-sm btn-danger\" (click)=\"removeAllTutorials()\">
      Remove All
    </button>
  </div>
  <div class=\"col-md-6\">
    <app-tutorial-details
      [viewMode]=\"true\"
      [currentTutorial]=\"currentTutorial\"
    ></app-tutorial-details>
  </div>
</div>" > tutorials-list.component.html
sudo mv tutorials-list.component.html MEAN/src/app/components/tutorials-list/tutorials-list.component.html

echo "Loading Application Files - tutorials-list.component.css"
sudo echo "
.list {
  text-align: left;
  max-width: 750px;
  margin: auto;
}" > tutorials-list.component.css
sudo mv tutorials-list.component.css MEAN/src/app/components/tutorials-list/tutorials-list.component.css

echo "Loading Application Files - add-tutorial.component.ts"
sudo echo "
import { Component, OnInit } from '@angular/core';
import { Tutorial } from 'src/app/models/tutorial.model';
import { TutorialService } from 'src/app/services/tutorial.service';

@Component({
  selector: 'app-add-tutorial',
  templateUrl: './add-tutorial.component.html',
  styleUrls: ['./add-tutorial.component.css']
})
export class AddTutorialComponent implements OnInit {

  tutorial: Tutorial = {
    title: '',
    description: '',
    published: false
  };
  submitted = false;

  constructor(private tutorialService: TutorialService) { }

  ngOnInit(): void {
  }

  saveTutorial(): void {
    const data = {
      title: this.tutorial.title,
      description: this.tutorial.description
    };

    this.tutorialService.create(data)
      .subscribe({
        next: (res) => {
          console.log(res);
          this.submitted = true;
        },
        error: (e) => console.error(e)
      });
  }

  newTutorial(): void {
    this.submitted = false;
    this.tutorial = {
      title: '',
      description: '',
      published: false
    };
  }

}" > add-tutorial.component.ts
sudo mv add-tutorial.component.ts MEAN/src/app/components/add-tutorial/add-tutorial.component.ts

echo "Loading Application Files - add-tutorial.component.html"
sudo echo "
<div>
  <div class=\"submit-form\">
    <div *ngIf=\"!submitted\">
      <div class=\"form-group\">
        <label for=\"title\">Title</label>
        <input
          type=\"text\"
          class=\"form-control\"
          id=\"title\"
          required
          [(ngModel)]=\"tutorial.title\"
          name=\"title\"
        />
      </div>

      <div class=\"form-group\">
        <label for=\"description\">Description</label>
        <input
          class=\"form-control\"
          id=\"description\"
          required
          [(ngModel)]=\"tutorial.description\"
          name=\"description\"
        />
      </div>

      <button (click)=\"saveTutorial()\" class=\"btn btn-success\">Submit</button>
    </div>

    <div *ngIf=\"submitted\">
      <h4>Tutorial was submitted successfully!</h4>
      <button class=\"btn btn-success\" (click)=\"newTutorial()\">Add</button>
    </div>
  </div>
</div>" > add-tutorial.component.html
sudo mv add-tutorial.component.html MEAN/src/app/components/add-tutorial/add-tutorial.component.html

echo "Loading Application Files - add-tutorial.component.css"
sudo echo "
.submit-form {
  max-width: 400px;
  margin: auto;
}" > add-tutorial.component.css
sudo mv add-tutorial.component.css MEAN/src/app/components/add-tutorial/add-tutorial.component.css

echo "Starting MEAN Front End Server"
cd MEAN/src
sudo ng serve
```

## Setup Backend (Express JS and MongoDB Configuration) Terminal #3
```
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
  console.log();
});" > server.js

sudo sed -i 's/console.log()/console.log(`Server is running on port ${PORT}.`)/' server.js

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

};" > routes/tutorial.routes.js

echo "Create models/index.js file"
sudo mkdir models
sudo echo "
const dbConfig = require('../config/db.config.js');

const mongoose = require('mongoose');
mongoose.Promise = global.Promise;

const db = {};
db.mongoose = mongoose;
db.url = dbConfig.url;
db.tutorials = require('./tutorial.model.js')(mongoose);

module.exports = db;" > models/index.js

echo "Create models/tutorial.model.js file"
sudo echo "
module.exports = mongoose => {
  var schema = mongoose.Schema(
    {
      title: String,
      description: String,
      published: Boolean
    },
    { timestamps: true }
  );

  schema.method('toJSON', function() {
    const { __v, _id, ...object } = this.toObject();
    object.id = _id;
    return object;
  });

  const Tutorial = mongoose.model('tutorial', schema);
  return Tutorial;
};" > models/tutorial.model.js

echo "Create controllers/tutorial.controller.js file"
sudo mkdir controllers
sudo echo "
const db = require('../models');
const Tutorial = db.tutorials;

// Create and Save a new Tutorial
exports.create = (req, res) => {
  // Validate request
  if (!req.body.title) {
    res.status(400).send({ message: 'Content can not be empty!' });
    return;
  }

  // Create a Tutorial
  const tutorial = new Tutorial({
    title: req.body.title,
    description: req.body.description,
    published: req.body.published ? req.body.published : false
  });

  // Save Tutorial in the database
  tutorial
    .save(tutorial)
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || 'Some error occurred while creating the Tutorial.'
      });
    });
};

// Retrieve all Tutorials from the database.
exports.findAll = (req, res) => {
  const title = req.query.title;
  var condition = title ? { title: { \$regex: new RegExp(title), \$options: 'i' } } : {};

  Tutorial.find(condition)
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || 'Some error occurred while retrieving tutorials.'
      });
    });
};

// Find a single Tutorial with an id
exports.findOne = (req, res) => {
  const id = req.params.id;

  Tutorial.findById(id)
    .then(data => {
      if (!data)
        res.status(404).send({ message: 'Not found Tutorial with id ' + id });
      else res.send(data);
    })
    .catch(err => {
      res
        .status(500)
        .send({ message: 'Error retrieving Tutorial with id=' + id });
    });
};

// Update a Tutorial by the id in the request
exports.update = (req, res) => {
  if (!req.body) {
    return res.status(400).send({
      message: 'Data to update can not be empty!'
    });
  }

  const id = req.params.id;

  Tutorial.findByIdAndUpdate(id, req.body, { useFindAndModify: false })
    .then(data => {
      if (!data) {
        res.status(404).send({
          message: 'Cannot update Tutorial with id=\${id}. Maybe Tutorial was not found!'
        });
      } else res.send({ message: 'Tutorial was updated successfully.' });
    })
    .catch(err => {
      res.status(500).send({
        message: 'Error updating Tutorial with id=' + id
      });
    });
};

// Delete a Tutorial with the specified id in the request
exports.delete = (req, res) => {
  const id = req.params.id;

  Tutorial.findByIdAndRemove(id)
    .then(data => {
      if (!data) {
        res.status(404).send({
          message: 'Cannot delete Tutorial with id=\${id}. Maybe Tutorial was not found!'
        });
      } else {
        res.send({
          message: 'Tutorial was deleted successfully!'
        });
      }
    })
    .catch(err => {
      res.status(500).send({
        message: 'Could not delete Tutorial with id=' + id
      });
    });
};

// Delete all Tutorials from the database.
exports.deleteAll = (req, res) => {
  Tutorial.deleteMany({})
    .then(data => {
      res.send({
        message: '\${data.deletedCount} Tutorials were deleted successfully!'
      });
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || 'Some error occurred while removing all tutorials.'
      });
    });
};

// Find all published Tutorials
exports.findAllPublished = (req, res) => {
  Tutorial.find({ published: true })
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || 'Some error occurred while retrieving tutorials.'
      });
    });
};" > controllers/tutorial.controller.js

echo "Create config/db.config.js file"
sudo mkdir config
sudo echo "
module.exports = {
  url: 'mongodb://localhost:27017/meancrud'
};" > config/db.config.js

echo "Starting Angular MEAN Backend Server"
sudo node server.js
```

## Test using Curl
Use Terminal #1 to test `curl http://localhost:4200`
