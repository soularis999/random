import { Component } from '@angular/core';

@Component({
  selector: 'app-loading',
  template: `
  <h1 [textContent]="loading"></h1>
  <input type="text" id="txt" [(ngModel)]="tempResult"/>
  <input type="button" (click)="onButtonClick($event)" value="submit"/>
   `
})
export class LoadingComponent {
  loading = 'loading';
  tempResult = '';

  onButtonClick = (e) => {
    e.stopPropagation();
    this.loading = this.tempResult;
  }
}
