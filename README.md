Faber
=====

Block based content editor

# TODOs

1.	Pluggable component templates
2.	Pluggable themes
3.	Setup publish task
4.	Responsive preview

## Grunt tasks

*	Use [grunt-angular-templates](https://github.com/ericclemmons/grunt-angular-templates) to prepare templates
*	[grunt-contrib-uglify](https://github.com/gruntjs/grunt-contrib-uglify)


# To get it started

```
npm install
./node_modules/protractor/bin/webdriver-manager update
grunt dev

```

## To start dev environment

```
grunt dev

```

This will run [Karma](http://karma-runner.github.io/ "Karma") [Jasmine](http://jasmine.github.io/) unit test in the background while watching file changes


## To run test tasks

[Protractor](https://github.com/angular/protractor "Protractor") is used to do acceptance(e2e) test and [Karma](http://karma-runner.github.io/ "Karma") with [Jasmine](http://jasmine.github.io/) is used to do unit test

```
./node_modules/protractor/bin/webdriver-manager start
grunt test

```

`webdriver-manager start` before `grunt test` so [Protractor](https://github.com/angular/protractor "Protractor") can run.

`grunt test` will run [Jasmine](http://jasmine.github.io/) task so the unit test result is accessible via browser and then [Karma](http://karma-runner.github.io/ "Karma") unit test and [Protractor](https://github.com/angular/protractor "Protractor") e2e test.

## To run Protractor manually

```
./node_modules/protractor/bin/webdriver-manager start

```
and then

```
grunt protractor

```
or


```
./node_modules/.bin/protractor test/config/protractor.conf.js

```

## To publish

[WIP]
