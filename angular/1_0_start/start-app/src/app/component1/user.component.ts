import { Component } from '@angular/core';

@Component({
  selector: 'app-user',
  template: `
    <h1>Hello!</h1>
    <p>I'm {{user}}</p>
    <p>I'm {{address}}</p>
    <input id="user" type="text" [(ngModel)]="user"><label for="user">User</label>
    <input id="address" type="text" [(ngModel)]="address"><label for="user">address</label>
  `
})
export class UserComponent {
  user = 'test';
  address = 'test';
}
