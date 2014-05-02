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
var concat = require('gulp-concat');
var minifyCss = require('gulp-minify-css');
var ngmin = require('gulp-ngmin');
var uglify = require('gulp-uglify');
var rename = require('gulp-rename');

var DEV_DIR = './dev';
var DIST_DIR = './dist';

var SRC_FILES = [
        DEV_DIR + '/js/lib/angular/angular.js',
        DEV_DIR + '/js/lib/angular-animate/angular-animate.js',
        DEV_DIR + '/js/lib/angular-mocks/angular-mocks.js',
        DEV_DIR + '/js/faber/classes/FaberComponent.js',
        DEV_DIR + '/js/faber/faber.js',
        DEV_DIR + '/js/faber/**/*.js'
];

var DIST_FILES = [
        DEV_DIR + '/js/faber/classes/FaberComponent.js',
        DEV_DIR + '/js/faber/faber.js',
        DEV_DIR + '/js/faber/**/*.js'
];

var BUILTIN_COMPONENTS = [
        DEV_DIR + '/js/lib/medium-editor/dist/js/medium-editor.js',
        DEV_DIR + '/js/components/**/*.js',
];

var TEST_FILES = [
    './test/helpers/**/*.coffee',
    './test/unit/**/*.coffee'
];

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
    return gulp.src(['.src/*.jade', './src/**/*.jade', '!./src/dist.jade', '!./src/directive-templates/**/*'])
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
    return bower();
});

gulp.task('templatecache', function () {
    return gulp.src('./src/directive-templates/**/*.jade')
        .pipe(jade())
        .pipe(templateCache({ module: 'faber' }))
        .pipe(gulp.dest(DEV_DIR + '/js/faber/directives'));
});

gulp.task('dev-copy-icons', function() {
    return gulp.src([
        './src/css/fonts/*'
    ])
        .pipe(gulp.dest(DEV_DIR + '/css/fonts'));
});

gulp.task('dist-copy-icons', function() {
    return gulp.src([
        './src/css/fonts/*'
    ])
        .pipe(gulp.dest(DIST_DIR + '/fonts'));
});

gulp.task('dist-copy-angular', ['build'], function() {
    return gulp.src([DEV_DIR + '/js/lib/angular/angular.js', DEV_DIR + '/js/lib/angular-animate/angular-animate.js', DEV_DIR + '/js/lib/angular-mocks/angular-mocks.js'])
        .pipe(gulp.dest(DIST_DIR));
});

gulp.task('dist-build-js', ['build'], function() {
    return gulp.src(BUILTIN_COMPONENTS.concat(DIST_FILES))
        .pipe(concat('faber.js'))
        .pipe(gulp.dest(DIST_DIR))
        .pipe(uglify({mangle: false}))
        .pipe(rename('faber.min.js'))
        .pipe(gulp.dest(DIST_DIR));
});

gulp.task('dist-build-css', ['build'], function() {
    return gulp.src(['./dev/js/lib/medium-editor/dist/css/medium-editor.css', './dev/css/**/*.css'])
        .pipe(concat('faber.css'))
        .pipe(gulp.dest(DIST_DIR))
        .pipe(minifyCss())
        .pipe(rename('faber.min.css'))
        .pipe(gulp.dest(DIST_DIR));
});

gulp.task('dist-build-demo', ['build'], function() {
    return gulp.src('./src/dist.jade')
        .pipe(jade())
        .pipe(gulp.dest(DIST_DIR));
});

gulp.task('dist-build', ['dist-copy-icons', 'dist-copy-angular', 'dist-build-js', 'dist-build-css', 'dist-build-demo']);

gulp.task('dist-test', ['dist-build'], function() {
    return gulp.src([DIST_DIR + '/angular.js', DIST_DIR + '/angular-animate.js', DIST_DIR + '/angular-mocks.js', DIST_DIR + '/faber.js'].concat(TEST_FILES))
        .pipe(karma({
            configFile: 'test/config/karma.conf.js'
        }))
        .on('error', function(e) { throw e });
});

gulp.task('dist-min-test', ['dist-build'], function() {
    return gulp.src([DIST_DIR + '/angular.js', DIST_DIR + '/angular-animate.js', DIST_DIR + '/angular-mocks.js', DIST_DIR + '/faber.min.js'].concat(TEST_FILES))
        .pipe(karma({
            configFile: 'test/config/karma.conf.js'
        }));
});

gulp.task('karma', ['build'], function() {
    return gulp.src(BUILTIN_COMPONENTS.concat(SRC_FILES).concat(TEST_FILES)).pipe(karma({
        configFile: 'test/config/karma.conf.js',
        action: 'watch'
    }));
});

gulp.task('karma-specs', ['build'], function() {
    return gulp.src(BUILTIN_COMPONENTS.concat(SRC_FILES).concat(TEST_FILES)).pipe(karma({
        configFile: 'test/config/karma.conf.js'
    }))
    .on('error', function(e) { throw e });
});

gulp.task('webdriver_update', webdriver_update);

gulp.task('protractor', ['webdriver_update'], function() {
    return gulp.src(['./test/e2e/**/*.coffee'])
        .pipe(coffee())
        .pipe(gulp.dest('./test/e2e'))
        .pipe(protractor({
            configFile: "test/config/protractor.conf.js",
            args: ['--baseUrl', 'http://localhost:1337/']
        }))
//        .on('error', function(e) { throw e })
});

gulp.task('browserstack', function() {
    return gulp.src(['./test/e2e/**/*.coffee'])
        .pipe(coffee())
        .pipe(gulp.dest('./test/e2e'))
        .pipe(protractor({
            configFile: "test/config/browserstack.conf.js",
            args: ['--baseUrl', 'http://test-faber.herokuapp.com/']
        }))
        .on('error', function(e) { throw e })
});

gulp.task('watch', ['connect'], function() {
    gulp.watch(['./src/**/*.coffee', './test/**/*.coffee'], ['coffee']);
    gulp.watch(['./src/**/*.jade'], ['jade', 'templatecache']);
    gulp.watch(['./src/**/*.sass'], ['sass']);
});

gulp.task('install', ['bower']);
gulp.task('build', ['coffee', 'jade', 'sass', 'templatecache', 'dev-copy-icons']);

gulp.task('dev', ['build', 'watch']);
gulp.task('devtest', ['karma', 'watch']);
gulp.task('specs', ['karma-specs']);
gulp.task('dist', ['dist-test', 'dist-min-test']);

gulp.task('default', ['install', 'build']);
