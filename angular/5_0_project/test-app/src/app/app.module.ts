import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';
import { ItemComponent } from './item/item.component';
import { UserService } from './user.service';
import { LoggerService } from './logger.service';
import { NavigationComponent } from './navigation/navigation.component';
import { ListComponent } from './list/list.component';
import { TabComponent } from './tab/tab.component';
import { AppRoutingModule  } from './app-routing.module';
import { CreateCharacterModule } from './character-create/character-create.module';



@NgModule({
  /*
  different components exposed
  */
  declarations: [
    AppComponent,
    ItemComponent,
    NavigationComponent,
    ListComponent,
    TabComponent
  ],
  /*
  Modules - FormsModule allows different functionality to work
  e.g. *ngIf or #name="ngForm"
  */
  imports: [
    BrowserModule,
    FormsModule,
    HttpClientModule,
    AppRoutingModule,
    CreateCharacterModule
  ],
  /*
  Define services that will be wired in the app
  */
  providers: [UserService, LoggerService],
  bootstrap: [AppComponent]
})
export class AppModule { }
