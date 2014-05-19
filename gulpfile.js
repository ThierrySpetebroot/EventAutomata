var
  gulp    = require('gulp'),
  gutil   = require('gulp-util'),
  concat  = require('gulp-concat'),
  coffee  = require('gulp-coffee'),
  jasmine = require('gulp-jasmine'),

  pkg = require('./package.json');

var paths = {
  tests: './tests/**/*'
}

console.log("Init " + pkg.name + " build system\n")

gulp.task('test-compile', function() {
  return gulp.src(paths.tests + '.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./tests/'))
})

gulp.task('test', ['test-compile'], function() {
  return gulp.src(paths.tests + '.js')
    .pipe(jasmine())
})

var files = ['EventMapper', 'EventDispatcher', 'Automata', 'AutomataUI']
gulp.task('compile', function() {
  for (var i = files.length - 1; i >= 0; i--) {
    files[i] = './src/impl/' + files[i] + '.js';
  };

  gulp.src(files)
    .pipe(concat('all.js'))
    .pipe(gulp.dest('./examples/'));

  files.push('./build-conf/exports.js');
  gulp.src(files)
    .pipe(concat('all.js'))
    .pipe(gulp.dest('./dist/'));
});
