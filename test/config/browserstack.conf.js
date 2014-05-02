require('coffee-script');
var browsers = require('../../.browsers.json');

var username = process.env.BS_USERNAME;
var key = process.env.BS_AUTHKEY;
var project = process.env.CIRCLE_PROJECT_REPONAME
var build_num = process.env.CIRCLE_BUILD_NUM

for(var i=0 ; i < browsers.length ; ++i) {
    b = browsers[i];
    b['browserstack.user'] = username;
    b['browserstack.key'] = key;
    b['browserstack.project'] = project;
    b['browserstack.build'] = build_num;
}


exports.config = {
    seleniumAddress: 'http://hub.browserstack.com/wd/hub',

    chromeOnly: false,

    multiCapabilities: browsers,

  onPrepare: function() {
    global.By = protractor.by;
  },


    // Options to be passed to Jasmine-node.
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000
  }
};
