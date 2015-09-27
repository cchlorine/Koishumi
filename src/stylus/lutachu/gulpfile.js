var gulp   = require('gulp'),
    del    = require('del'),
    sass   = require('gulp-sass'),
    concat = require('gulp-concat'),
    stylus = require('gulp-stylus'),
    rename = require('gulp-rename'),
    sourcemaps   = require('gulp-sourcemaps'),
    minifycss    = require('gulp-minify-css'),
    livereload   = require('gulp-livereload'),
    autoprefixer = require('gulp-autoprefixer');

gulp.task('clean', function() {
  return del('dist/**/*.*');
});

gulp.task('stylus', function() {
  return gulp.src([
      'src/normalize.styl',
      'src/typography/typography.styl',
      'src/fonts/*.styl',
      'src/layout/*.styl',
      'src/typography/**/*.styl',
      'src/elements/*.styl',
      'src/components/*.styl',
      'src/utilities.styl',
      'src/print.styl'
    ])
    .pipe(stylus())
    .pipe(sourcemaps.init())
    .pipe(autoprefixer(['last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4']))
    .pipe(concat('lutachu.css'))
    .pipe(gulp.dest('dist'))
    .pipe(minifycss())
    .pipe(concat('lutachu.min.css'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('dist'))
    .pipe(livereload());
});

gulp.task('scss', function() {
  return gulp.src('sass/lutachu.scss')
    .pipe(sass())
    .pipe(sourcemaps.init())
    .pipe(autoprefixer(['last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4']))
    .pipe(gulp.dest('dist'))
    .pipe(minifycss())
    .pipe(rename({suffix: '.min'}))
    .pipe(gulp.dest('dist'))
    .pipe(sourcemaps.write('./'))
    .pipe(livereload());
});

gulp.task('fonts', function() {
  return gulp.src('fonts/**')
    .pipe(gulp.dest('dist/fonts'));
});

gulp.task('default', ['clean'], function() {
  gulp.start('stylus', 'fonts');
});

gulp.task('sass', ['clean'], function() {
  gulp.start('scss', 'fonts');
});

gulp.task('watch', function() {
  gulp.watch('src/**/*.styl', ['stylus']);
  livereload.listen();
});

gulp.task('watch-sass', function() {
  gulp.watch('sass/**/*.scss', ['scss']);
  livereload.listen();
});
