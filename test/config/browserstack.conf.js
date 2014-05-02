require('coffee-script');

username = process.env.BS_USERNAME;
key = process.env.BS_AUTHKEY;

// An example configuration file.
exports.config = {
  // The file path to the selenium server jar ()
    seleniumAddress: 'http://hub.browserstack.com/wd/hub',

    chromeOnly: false,

    capabilities: {
        'browserName': 'chrome',
        'browserstack.user': username,
        'browserstack.key': key
    },

    /*multiCapabilities: [
        {
            'browserName': 'chrome'
        },
        {
            'browserName': 'firefox'
        }
    ],*/

  onPrepare: function() {
    global.By = protractor.by;
  },


    // Options to be passed to Jasmine-node.
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000
  }
};
