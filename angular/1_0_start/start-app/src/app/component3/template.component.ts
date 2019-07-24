import { Component, Input , Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-template',
  templateUrl: 'template.component.html'
})
export class TemplateComponent {
  @Input() nameStr = 'loading';
  @Output() nameChanged = new EventEmitter<string>();

  onButtonClick = (e) => {
    this.nameChanged.emit(this.nameStr);
  }
}
