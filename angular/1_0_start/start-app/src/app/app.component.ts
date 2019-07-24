import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  name = 'start-app';
  items = ['Apples', 'Bananas', 'Cherries'];

  onNameChanged = (e) => {
    console.log(`In app component on name change ${e}`);
  }

  onItemAdded = (e) => {
    this.items.push(e);
  }
}
