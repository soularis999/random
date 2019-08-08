const { of, interval } = require('rxjs');
const { map, filter, throttle, mergeMap } = require('rxjs/operators');

const source = of(1,2,3,4,5);
const sub = source
      .pipe(filter(val => val > 1))
      .pipe(map(val => val + 1))
      .subscribe(val => console.log(val));

const obs2 = source.pipe(map(val => val * val),
                         throttle(() => interval(2000)));
obs2.subscribe(val => console.log("Test 2.1", val));
obs2.subscribe(val => console.log("Test 2.2", val));

const obs3 = source.pipe(mergeMap(val => of(`Test ${val}`)))
obs3.subscribe(val => console.log("Test3.1", val))
obs3.subscribe(val => console.log("Test3.2", val));
      
