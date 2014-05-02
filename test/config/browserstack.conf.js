require('coffee-script');

// An example configuration file.
exports.config = {
  // The file path to the selenium server jar ()
  seleniumServerJar: 'http://hub.browserstack.com/wd/hub',

    chromeOnly: false,

    multiCapabilities: [
        {
            'browserName': 'chrome'
        },
        {
            'browserName': 'firefox'
        }
    ],

  onPrepare: function() {
    global.By = protractor.by;
  },


    // Options to be passed to Jasmine-node.
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000
  },

    params: {
        login: {
            user: process.env.BS_USERNAME,
            password: process.env.BS_PASSWORD
        }
    }
};
