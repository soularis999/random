import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { CharacterCreateComponent } from './character-create.component';

@NgModule({
  declarations: [
    CharacterCreateComponent
  ],
  imports: [
    FormsModule,
    CommonModule,
    RouterModule.forChild([
      { path: '', component: CharacterCreateComponent }
    ])
  ]
})
export class CreateCharacterModule { }
