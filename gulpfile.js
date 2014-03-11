var gulp = require('gulp');
var coffee = require('gulp-coffee');
var jade = require('gulp-jade');
var templateCache = require('gulp-angular-templatecache');
var karma = require('gulp-karma');
var bower = require('gulp-bower');
var protractor = require("gulp-protractor").protractor;
var webdriver_update = require("gulp-protractor").webdriver_update;

var DEV_DIR = './dev';

gulp.task('coffee', function() {
    return gulp.src('./src/**/*.coffee')
        .pipe(coffee({bare: true}))
        .pipe(gulp.dest(DEV_DIR));
});

gulp.task('jade', function() {
    return gulp.src(['./src/**/*.jade', '!./src/directive-templates/**/*'])
        .pipe(jade())
        .pipe(gulp.dest(DEV_DIR))
});

gulp.task('bower', function() {
    bower();
});

gulp.task('templatecache', function () {
    gulp.src('./src/directive-templates/**/*.jade')
        .pipe(jade())
        .pipe(templateCache({ standalone: true }))
        .pipe(gulp.dest(DEV_DIR + '/js/faber/directives'));
});

gulp.task('karma', function() {
    return gulp.src([
        DEV_DIR + '/js/lib/angular/angular.js',
        DEV_DIR + '/js/lib/angular-mocks/angular-mocks.js',
        DEV_DIR + '/js/faber/classes/FaberComponent.js',
        DEV_DIR + '/js/faber/directives/templates.js',
        DEV_DIR + '/js/faber/faber.js',
        DEV_DIR + '/js/faber/**/*.js',
//        './src/js/faber/faber.coffee',
//        './src/js/faber/**/*.coffee',
        './test/helpers/**/*.coffee',
        './test/unit/**/*.coffee'
    ]).pipe(karma({
        configFile: 'test/config/karma.conf.js',
        action: 'watch'
    }));
});

gulp.task('karma-specs', function() {
    return gulp.src([
        DEV_DIR + '/js/lib/angular/angular.js',
        DEV_DIR + '/js/lib/angular-mocks/angular-mocks.js',
        DEV_DIR + '/js/faber/directives/templates.js',
        './src/js/faber/faber.coffee',
        './src/js/faber/**/*.coffee',
        './test/helpers/**/*.coffee',
        './test/unit/**/*.coffee'
    ]).pipe(karma({
        configFile: 'test/config/karma.conf.js'
    }));
});

gulp.task('webdriver_update', webdriver_update);

gulp.task('protractor', ['webdriver_update'], function() {
    gulp.src(['./test/e2e/FaberUISpec.coffee'])
        .pipe(coffee({bare: true}))
        .pipe(protractor({
            configFile: "test/config/protractor.conf.js",
            args: ['--baseUrl', 'http://127.0.0.1:8000']
        }))
        .on('error', function(e) { throw e })
});

gulp.task('watch', function() {
    gulp.watch(['./src/**/*.coffee', './test/**/*.coffee'], ['coffee']);
    gulp.watch(['./src/**/*.jade'], ['jade', 'templatecache']);
});

gulp.task('default', ['coffee', 'jade', 'bower', 'templatecache']);
gulp.task('dev', ['coffee', 'jade', 'templatecache', 'karma', 'watch']);
gulp.task('specs', ['coffee', 'jade', 'karma-specs']);
