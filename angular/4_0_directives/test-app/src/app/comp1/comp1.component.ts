import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-comp1',
  templateUrl: './comp1.component.html',
  styleUrls: ['./comp1.component.css']
})
export class Comp1Component implements OnInit {

  @Input() data = [];
  @Output() dataUpdate = new EventEmitter<string>();
  temp = '';

  constructor() { }

  ngOnInit() {
  }

  onAdd = () => {
    this.dataUpdate.emit(this.temp);
    this.temp = '';
  }
}
