require('coffee-script');

// An example configuration file.
exports.config = {
  // The file path to the selenium server jar ()
  seleniumServerJar: '../../node_modules/protractor/selenium/selenium-server-standalone-2.40.0.jar',

  // The address of a running selenium server.
  // seleniumAddress: 'http://localhost:4444/wd/hub',

  // Capabilities to be passed to the webdriver instance.
  capabilities: {
    'browserName': 'chrome'
  },

  // Spec patterns are relative to the current working directly when
  // protractor is called.
//  specs: [
//      './test/e2e/**/*Spec.coffee'
//  ],

  onPrepare: function() {
    global.By = protractor.by;
  },

  // Options to be passed to Jasmine-node.
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000
  }
};
