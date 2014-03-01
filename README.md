Faber
=====

Block based content editor


```
npm install
./node_modules/protractor/bin/webdriver-manager update
grunt dev

```

Protractor is used to do acceptance test and Karma with Jasmine is used to do unit test


# To start dev environment

```
grunt dev

```
This will run Karma unit test in the background while watching file changes


# To run test tasks

```
grunt test

```
This will run Jasmine task so the unit test result is accessible via browser with Karma unit test and Protractor e2e test

# To run Protractor manually

```
./node_modules/protractor/bin/webdriver-manager start

```
and

```
grunt protractor

```
or


```
./node_modules/.bin/protractor test/config/protractor.conf.js

```

# To publish

wip
