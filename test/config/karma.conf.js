module.exports = function(config){
  config.set({
    basePath: '../../',

    files: [
//      'app/lib/angular/angular-*.js',
      'dev/lib/angular.js',
      'test/lib/angular-mocks.js',
      'dev/lib/**/*.js',
      'dev/js/faber/faber.js',
      'dev/js/faber/**/*.js',
      'test/unit/**/*Spec.coffee'
    ],

    exclude: [
//      'app/lib/angular/angular-loader.js',
//      'app/lib/angular/*.min.js',
//      'app/lib/angular/angular-scenario.js'
    ],

    preprocessors: {
      '**/*.coffee': ['coffee']
    },

    autoWatch: false,

    port: 9018,
    runnerPort: 9101,

    frameworks: ['jasmine'],

    browsers: ['PhantomJS'],

    plugins: [
      'karma-phantomjs-launcher',
      'karma-coffee-preprocessor',
      'karma-chrome-launcher',
      'karma-firefox-launcher',
      'karma-jasmine',
      'karma-coverage'
    ]

//    junitReporter : {
//      outputFile: 'test_out/unit.xml',
//      suite: 'unit'
//    }

  })}