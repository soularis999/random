'use strict';

import { Injectable } from '@angular/core';
import { LoggerService } from './logger.service';
import { Subject } from 'rxjs/Subject';
import { Subscription } from 'rxjs/Subscription';
import { HttpClient } from '@angular/common/http';

import 'rxjs/add/operator/map';
/**
 * Injactable indicates that the class can get stuff injected into it
 * provided in root means that root module provides fiels so that new instance
 * would not be created
 */
@Injectable()
export class UserService {
  private logger: LoggerService;
  private http: HttpClient;
  private characters = [];
  private charactersChanged = new Subject<void>();

  constructor(logger: LoggerService, http: HttpClient) {
    this.logger = logger;
    this.http = http;
  }

  fetchCharacters = () => {
    this.http.get('http://swapi.co/api/people/')
      .map((data) => data['results'].map((item) => {
        return { name: item.name, side: '' };
      }))
      .subscribe(
        (data) => {
          this.characters = data;
          this.notify();
        },
        (error: Error) => {
          console.log('Error', error);
        }
      );
  }

  subscribe = (listener): Subscription => {
    return this.charactersChanged.subscribe(listener);
  }

  getCharacters = (charType) => {
    if (charType === 'all') {
      return this.characters.slice();
    }
    return this.characters.filter((char) => char.side === charType);
  }

  setCharacter = (username, side) => {
    this.logger.log(`Adding character for ${username} and ${side}`);
    const index = this.characters.findIndex(char => {
      return char.name === username;
    });
    this.characters[index].side = side;
    this.notify();
  }

  addCharacter = (name: string, side: string) => {
    const newChar = { name, side };
    this.characters.push(newChar);
  }

  notify = () => {
    this.charactersChanged.next();
  }
}
