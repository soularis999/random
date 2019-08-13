import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { UserService } from '../user.service';
import { Subscription } from 'rxjs/Subscription';

@Component({
  selector: 'app-list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.css']
})
export class ListComponent implements OnInit, OnDestroy {
  characters = [];
  activatedRoute: ActivatedRoute;
  userService: UserService;
  loadedSide = 'all';

  userServiceSubscription: Subscription;

  constructor(activatedRoute: ActivatedRoute, userService: UserService) {
    this.activatedRoute = activatedRoute;
    this.userService = userService;
  }

  ngOnInit() {
    this.activatedRoute.params.subscribe(
      (params) => {
        /*
        the observable is used to callback on parse;
        the side in params is the same name we defined in route definition in module
        */
        console.log(params);

        this.characters = this.userService.getCharacters(params.side);
        this.loadedSide = params.side;
      },
      (error) => { },
      /*
      onEnd
      */
      () => { }
    );

    /*
    Subscrbe to change in character
    */
    this.userServiceSubscription = this.userService.subscribe(
      () => {
        this.characters = this.userService.getCharacters(this.loadedSide);
      }
    );
  }

  /*
  Otherwise we keep holding and addig more and more connections
  */
  ngOnDestroy() {
    this.userServiceSubscription.unsubscribe();
  }
}
