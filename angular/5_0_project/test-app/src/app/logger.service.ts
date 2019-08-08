import { Injectable } from '@angular/core';

export class LoggerService {

  constructor() { }

  log = (message) => {
    console.log(message);
  }
}
