import { Component, OnInit } from '@angular/core';

import { UserService } from '../user.service';

@Component({
  selector: 'app-character-create',
  templateUrl: './character-create.component.html',
  styleUrls: ['./character-create.component.css']
})
export class CharacterCreateComponent implements OnInit {
  sides = [
    {displayValue: 'None', value: ''},
    {displayValue: 'Light', value: 'light'},
    {displayValue: 'Dark', value: 'dark'}
  ];
  userService: UserService;

  constructor(userService: UserService) {
    this.userService = userService;
  }

  ngOnInit() {
  }

  onSubmit = (thisform) => {
    if(thisform.invalid) {
      return;
    }
    console.log(thisform.value);
    this.userService.addCharacter(thisform.value.name, thisform.value.side);
  }
}
