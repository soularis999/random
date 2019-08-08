import { BrowserModule } from '@angular/platform-browser';
import { NgModule, ANALYZE_FOR_ENTRY_COMPONENTS } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';

import { AppComponent } from './app.component';
import { ListComponent } from './list/list.component';
import { TabComponent } from './tab/tab.component';
import { ItemComponent } from './item/item.component';
import { UserService } from './user.service';
import { LoggerService } from './logger.service';
import { CharacterCreateComponent } from './character-create/character-create.component';
import { NavigationComponent } from './navigation/navigation.component';

const router = [
  {path: 'characters', component: TabComponent, children: [
    /*
    Children are reletive to parent in url
    also url can contain vairable part as in /character/light or character/dark
    */
    { path: '', redirectTo: 'all', pathMatch: 'full' },
    { path: ':side', component: ListComponent }
  ]},
  {path: 'new-character', component: CharacterCreateComponent },
  /* The catch all route has to be in the end */
  {path: '**', redirectTo: '/characters/all' }
];

@NgModule({
  /*
  different components exposed
  */
  declarations: [
    AppComponent,
    ListComponent,
    TabComponent,
    ItemComponent,
    CharacterCreateComponent,
    NavigationComponent
  ],
  /*
  Modules - FormsModule allows different functionality to work
  e.g. *ngIf or #name="ngForm"
  */
  imports: [
    BrowserModule,
    FormsModule,
    /* route component wiring with list of routs */
    RouterModule.forRoot(router)
  ],
  /*
  Define services that will be wired in the app
  */
  providers: [UserService, LoggerService],
  bootstrap: [AppComponent]
})
export class AppModule { }
