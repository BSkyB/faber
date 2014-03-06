module.exports = function(config){
  config.set({
    basePath: '../../',

    preprocessors: {
      '**/*.coffee': ['coffee']
    },

    port: 9018,
    runnerPort: 9101,

    frameworks: ['jasmine'],

    browsers: ['PhantomJS'],

    reporters: ['dots'],

    plugins: [
      'karma-phantomjs-launcher',
      'karma-coffee-preprocessor',
      'karma-chrome-launcher',
      'karma-firefox-launcher',
      'karma-jasmine',
      'karma-coverage'
    ]

  })}