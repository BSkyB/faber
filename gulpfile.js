var gulp = require('gulp');
var coffee = require('gulp-coffee');
var jade = require('gulp-jade');
var sass = require('gulp-ruby-sass');
var templateCache = require('gulp-angular-templatecache');
var karma = require('gulp-karma');
var bower = require('gulp-bower');
var connect = require('gulp-connect');
var protractor = require("gulp-protractor").protractor;
var webdriver_update = require("gulp-protractor").webdriver_update;

var DEV_DIR = './dev';

gulp.task('connect', connect.server({
  root: ['dev'],
  port: 1337
}));

gulp.task('coffee', function() {
    return gulp.src('./src/**/*.coffee')
        .pipe(coffee({bare: true}))
        .pipe(gulp.dest(DEV_DIR));
});

gulp.task('jade', function() {
    return gulp.src(['./src/**/*.jade', '!./src/directive-templates/**/*'])
        .pipe(jade().on('error', function(err) {
            console.log(err);
        }))
        .pipe(gulp.dest(DEV_DIR))
});

gulp.task('sass', function() {
    return gulp.src('./src/**/*.sass')
        .pipe(sass({
            compass: true,
            loadPath: './src/css'
        }))
        .pipe(gulp.dest(DEV_DIR));
});

gulp.task('bower', function() {
    bower();
});

gulp.task('templatecache', function () {
    gulp.src('./src/directive-templates/**/*.jade')
        .pipe(jade())
        .pipe(templateCache({ module: 'faber' }))
        .pipe(gulp.dest(DEV_DIR + '/js/faber/directives'));
});

gulp.task('karma', function() {
    return gulp.src([
        DEV_DIR + '/js/lib/angular/angular.js',
        DEV_DIR + '/js/lib/angular-mocks/angular-mocks.js',
        DEV_DIR + '/js/faber/classes/FaberComponent.js',
        DEV_DIR + '/js/components/**/*.js',
        DEV_DIR + '/js/faber/faber.js',
        DEV_DIR + '/js/faber/**/*.js',
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
        DEV_DIR + '/js/faber/classes/FaberComponent.js',
        DEV_DIR + '/js/faber/faber.js',
        DEV_DIR + '/js/faber/**/*.js',
        './test/helpers/**/*.coffee',
        './test/unit/**/*.coffee'
    ]).pipe(karma({
        configFile: 'test/config/karma.conf.js'
    }));
});

gulp.task('webdriver_update', webdriver_update);

gulp.task('protractor', ['webdriver_update'], function() {
    gulp.src(['./test/e2e/**/*.coffee'])
        .pipe(coffee())
        .pipe(gulp.dest('./test/e2e'))
        .pipe(protractor({
            configFile: "test/config/protractor.conf.js",
            args: ['--baseUrl', 'http://localhost:1337/']
        }))
        .on('error', function(e) { throw e })
});

gulp.task('watch', function() {
    gulp.watch(['./src/**/*.coffee', './test/**/*.coffee'], ['coffee']);
    gulp.watch(['./src/**/*.jade'], ['jade', 'templatecache']);
    gulp.watch(['./src/**/*.sass'], ['sass']);
});

gulp.task('default', ['coffee', 'jade', 'sass', 'bower', 'templatecache']);
gulp.task('dev', ['coffee', 'jade', 'sass', 'connect', 'templatecache', 'watch']);
gulp.task('devtest', ['coffee', 'jade', 'sass', 'connect', 'templatecache', 'karma', 'watch']);
gulp.task('specs', ['coffee', 'jade', 'templatecache', 'karma-specs']);
