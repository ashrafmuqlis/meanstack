#!/bin/bash

echo "Loading Application Files - app.module.ts"
cd MEAN/src/app/
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
cd /home/vagrant/

echo "Loading Application Files - app-routing.module.ts"
cd MEAN/src/app/
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
cd /home/vagrant/

echo "Loading Application Files - styles.css"
cd MEAN/src/
sudo echo "
@import \"bootstrap/dist/css/bootstrap.css\";" > styles.css
cd /home/vagrant/

echo "Loading Application Files - app.component.html"
cd MEAN/src/app/
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
cd /home/vagrant/

echo "Loading Application Files - tutorial.model.ts"
cd MEAN/src/app/models/
sudo echo "
export class Tutorial {
  id?: any;
  title?: string;
  description?: string;
  published?: boolean;
}" > tutorial.model.ts
cd /home/vagrant/

echo "Loading Application Files - tutorial.service.ts"
cd MEAN/src/app/services/
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
    return this.http.get<Tutorial>(`\${baseUrl}/\${id}`);
  }

  create(data: any): Observable<any> {
    return this.http.post(baseUrl, data);
  }

  update(id: any, data: any): Observable<any> {
    return this.http.put(`\${baseUrl}/\${id}`, data);
  }

  delete(id: any): Observable<any> {
    return this.http.delete(`\${baseUrl}/\${id}`);
  }

  deleteAll(): Observable<any> {
    return this.http.delete(baseUrl);
  }

  findByTitle(title: any): Observable<Tutorial[]> {
    return this.http.get<Tutorial[]>(`\${baseUrl}?title=\${title}`);
  }
}" > tutorial.service.ts
cd /home/vagrant/

echo "Loading Application Files - tutorial-details.component.ts"
cd MEAN/src/app/components/tutorial-details/
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
cd /home/vagrant/

echo "Loading Application Files - tutorial-details.component.html"
cd MEAN/src/app/components/tutorial-details/
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
cd /home/vagrant/

echo "Loading Application Files - tutorial-details.component.css"
cd MEAN/src/app/components/tutorial-details/
sudo echo "
.edit-form {
  max-width: 400px;
  margin: auto;
}" > tutorial-details.component.css
cd /home/vagrant/

echo "Loading Application Files - tutorials-list.component.ts"
cd MEAN/src/app/components/tutorials-list/
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
cd /home/vagrant/

echo "Loading Application Files - tutorials-list.component.html"
cd MEAN/src/app/components/tutorials-list/
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
cd /home/vagrant/

echo "Loading Application Files - tutorials-list.component.css"
cd MEAN/src/app/components/tutorials-list/
sudo echo "
.list {
  text-align: left;
  max-width: 750px;
  margin: auto;
}" > tutorials-list.component.css
cd /home/vagrant/

echo "Loading Application Files - add-tutorial.component.ts"
cd MEAN/src/app/components/add-tutorial/
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
cd /home/vagrant/

echo "Loading Application Files - add-tutorial.component.html"
cd MEAN/src/app/components/add-tutorial/
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
cd /home/vagrant/

echo "Loading Application Files - add-tutorial.component.css"
cd MEAN/src/app/components/add-tutorial/
sudo echo "
.submit-form {
  max-width: 400px;
  margin: auto;
}" > add-tutorial.component.css
cd /home/vagrant/

echo "Starting MEAN Front End Server"
sudo ng MEAN/src/ serve
