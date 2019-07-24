import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  items = ['Apple', 'Pear', 'Blueberry'];
  onDataUpdate = (e) => {
    this.items.push(e);
  }
}
