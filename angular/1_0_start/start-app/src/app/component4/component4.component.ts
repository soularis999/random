import { Component, OnInit, Input, Output, EventEmitter} from '@angular/core';

import { trim } from 'lodash';

@Component({
  selector: 'app-component4',
  templateUrl: './component4.component.html',
  styleUrls: ['./component4.component.css']
})
export class Component4Component implements OnInit {

  inputResult;
  @Input() items = [];
  @Output() itemAdded = new EventEmitter<string>();

  constructor() {
  }

  ngOnInit() {
  }

  onAdd = (event) => {
    if (this.inputResult && '' !== this.inputResult.trim()) {
      this.itemAdded.emit(trim(this.inputResult));
    }
  }
}
