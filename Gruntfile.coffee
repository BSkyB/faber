module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-angular-templates'
  grunt.loadNpmTasks 'grunt-slim'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-protractor-runner'

  testConfig = (configFile, customOptions)->
    options =
      configFile: configFile
      singleRun: true
    travisOptions = process.env.TRAVIS && { browsers: ['Firefox', 'PhantomJS'], reporters: ['dots'] }
    grunt.util._.extend options, customOptions, travisOptions

  grunt.initConfig
    watch:
      coffee:
        files: ['**/*.coffee']
        tasks: ['coffee', 'karma:unit:run', 'jasmine']
#        tasks: ['coffee']
      jade:
        files: ['src/**/*.jade']
        tasks: 'jade'
      test:
        files: ['test/**/*.coffee']
        tasks: ['karma:unit:run', 'jasmine']

    coffee:
      compile:
#        options:
#          bare: true
        files: [
          cwd: 'src/'
          src: ['**/*.coffee']
          dest: 'dev/'
          expand: true
          ext: '.js'
        ]
      test:
        files: [
          cwd: 'test/unit/'
          src: ['**/*.coffee']
          dest: 'jasmine/'
          expand: true
          ext: '.js'
        ]

    slim:
      compile:
        options:
          client: false
          pretty: true
        files: [
          cwd: 'src/'
          src: ['**/*.slim']
          dest: 'dev/'
          expand: true
          ext: '.html'
        ]

    jade:
      compile:
        options:
          client: false
          pretty: true
        files: [
          cwd: 'src/'
          src: ['**/*.jade']
          dest: 'dev/'
          expand: true
          ext: '.html'
        ]

    copy:
      dev:
        files: [
          cwd: 'bower_components/medium-editor/dist/'
          src: '**'
          dest: 'dev/lib/medium-editor/'
          expand: true
          filter: 'isFile'
        ,
          src: 'node_modules/requirejs/require.js'
          dest: 'dev/lib/require.js'
        ,
          src: 'bower_components/angular/angular.js'
          dest: 'dev/lib/angular.js'
        ,
          src: 'bower_components/angular-local-storage/angular-local-storage.js'
          dest: 'dev/lib/angular-local-storage.js'
        ,
          src: 'bower_components/angular-medium-editor/dist/angular-medium-editor.js'
          dest: 'dev/lib/angular-medium-editor.js'
        ,
          src: 'bower_components/angular-slugify/angular-slugify.js'
          dest: 'dev/lib/angular-slugify.js'
        ,
          src: 'bower_components/angular-ui-utils/ui-utils.js'
          dest: 'dev/lib/angular-ui-utils.js'
        ]
      test:
        files: [
          src: 'bower_components/angular-mocks/angular-mocks.js'
          dest: 'test/lib/angular-mocks.js'
        ]

    connect:
      options:
        base: 'dev'
        open: true
        livereload: true
      server:
        options:
          keepalive: true
      continuous:
        options:
          keepalive: false

    karma:
      options:
        configFile: 'test/config/karma.conf.js'
#      unit: testConfig 'test/config/karma.conf.js'
      unit:
        background: true
        port: 9877
#      server:
#        configFile: 'test/config/karma.conf.js'
      continuous:
        singleRun: true
        background: false
#      coverage:
#        configFile: 'test/config/karma.conf.js'
#        reporters: ['progress', 'coverage']
#        preprocessors:
#          'dev/**/*.js': ['coverage']
#        coverageReporter:
#          type : 'html'
#          dir : 'coverage/'
#        singleRun: true

    protractor:
      options:
        configFile: 'node_modules/protractor/referenceConf.js'
        keepAlive: true
        noColor: false
      e2e:
        configFile: 'test/config/protractor.conf.js'

    jasmine:
      src: [
        'dev/js/faber/faber.js'
        'dev/**/*.js'
      ]
      options:
        specs: 'jasmine/**/*Spec.js'
        vendor: [
          'dev/lib/angular.js'
          'test/lib/angular-mocks.js'
        ]
#        helpers: 'test/helpers/helper.js'
        keepRunner: true

  grunt.registerTask 'default', ['coffee', 'jade', 'copy', 'karma:unit', 'protractor']
#  grunt.registerTask 'dev', ['coffee', 'jade', 'copy', 'karma:unit', 'connect:continuous', 'karma:continuous', 'watch']
  grunt.registerTask 'dev', ['coffee', 'jade', 'copy', 'karma:unit', 'karma:continuous', 'watch']
  grunt.registerTask 'test', ['coffee', 'jade', 'copy', 'jasmine', 'karma:unit', 'protractor']