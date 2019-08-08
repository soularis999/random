"use strict";

import { Injectable } from '@angular/core';
import { LoggerService } from './logger.service';
import { Subject } from 'rxjs/Subject';
import { Subscription } from 'rxjs/Subscription';
/**
 * Injactable indicates that the class can get stuff injected into it
 * provided in root means that root module provides fiels so that new instance
 * would not be created
 */
@Injectable({
  providedIn: 'root'
})
export class UserService {
  private logger: LoggerService;
  private characters = [
    { name: 'Luke', side: ''},
    { name: 'Darth', side: ''},
  ];
  private charactersChanged = new Subject<void>();

  constructor(logger: LoggerService) {
    this.logger = logger;
  }

  subscribe = (listener) : Subscription => {
    return this.charactersChanged.subscribe(listener);
  }

  getCharacters = (charType) => {
    if (charType === 'all') {
      return this.characters.slice();
    }
    return this.characters.filter((char) => char.side === charType);
  }

  setCharacter = (username, side) => {
    const index = this.characters.findIndex(char => {
      return char.name === username;
    });
    this.characters[index].side = side;

    this.charactersChanged.next();
    this.logger.log(`Adding character for ${username} and ${side}`);
  }

  addCharacter = (name: string, side: string) => {
    const newChar = {name, side};
    this.characters.push(newChar);
  }
}
