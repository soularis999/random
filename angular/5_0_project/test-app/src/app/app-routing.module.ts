import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';

import { ListComponent } from './list/list.component';
import { TabComponent } from './tab/tab.component';

const router = [
  {path: 'characters', component: TabComponent, children: [
    /*
    Children are reletive to parent in url
    also url can contain vairable part as in /character/light or character/dark
    */
    { path: '', redirectTo: 'all', pathMatch: 'full' },
    { path: ':side', component: ListComponent }
  ]},
  {path: 'new-character', loadChildren: './character-create/character-create.module#CreateCharacterModule' },
  /* The catch all route has to be in the end */
  {path: '**', redirectTo: '/characters/all' }
];

@NgModule({
  declarations: [],
  imports: [
    RouterModule.forRoot(router)
  ],
  exports: [
    RouterModule
  ]
})
export class AppRoutingModule { }
