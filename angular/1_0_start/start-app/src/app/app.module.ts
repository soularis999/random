import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { AppComponent } from './app.component';
import { UserComponent } from './component1/user.component';
import { LoadingComponent } from './component2/loading.component';
import { TemplateComponent } from './component3/template.component';
import { Component4Component } from './component4/component4.component';

@NgModule({
  declarations: [
    AppComponent,
    UserComponent,
    LoadingComponent,
    TemplateComponent,
    Component4Component
  ],
  imports: [
    BrowserModule,
    // NG model setup
    FormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
