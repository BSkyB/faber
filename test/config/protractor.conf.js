require('coffee-script');

// An example configuration file.
exports.config = {
  // The file path to the selenium server jar ()
  seleniumServerJar: '../../node_modules/protractor/selenium/selenium-server-standalone-2.41.0.jar',

  // Capabilities to be passed to the webdriver instance.
//  capabilities: {
//    'browserName': 'firefox'
//  },

    multiCapabilities: [
        {
            'browserName': 'chrome'
        },
        {
            'browserName': 'firefox'
        },
        {
            'browserName': 'safari'
        }
    ],

  onPrepare: function() {
    global.By = protractor.by;
  },


    // Options to be passed to Jasmine-node.
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000
  }
};
