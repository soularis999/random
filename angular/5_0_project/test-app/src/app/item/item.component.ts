import { Component, OnInit, Input } from '@angular/core';

import { UserService } from '../user.service';

@Component({
  selector: 'app-item',
  templateUrl: './item.component.html',
  styleUrls: ['./item.component.css']
})
export class ItemComponent implements OnInit {
  @Input() character;
  userService: UserService;

  constructor(userService: UserService) {
    this.userService = userService;
  }

  ngOnInit() {
  }

  onSideSelected = (side) => {
    this.userService.setCharacter(this.character.name, side);
  }
}
