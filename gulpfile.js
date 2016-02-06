var del = require('del'),
    gulp  = require('gulp'),

    concat = require('gulp-concat'),
    rename = require('gulp-rename'),

    jade   = require('gulp-jade'),
    stylus = require('gulp-stylus'),
    coffee = require('gulp-coffee'),

    uglify       = require('gulp-uglify'),
    autoprefixer = require('gulp-autoprefixer'),
    cssnano      = require('gulp-cssnano'),

    livereload = require('gulp-livereload')

gulp.task('jade', function() {
  return gulp.src('src/jade/**/*.jade')
    .pipe(jade({ pretty: true }))
	  .pipe(gulp.dest('dist'))
	  .pipe(livereload())
})

gulp.task('stylus', function() {
  return gulp.src('src/stylus/main.styl')
    .pipe(stylus())
    .pipe(autoprefixer('last 4 versions'))
    .pipe(cssnano())
    .pipe(gulp.dest('src/assets/style'))
    .pipe(livereload())
})

gulp.task('coffee', function() {
  return gulp.src('src/coffee/**/*.coffee')
    .pipe(coffee({ bare: true }))
    .pipe(uglify())
    .pipe(gulp.dest('src/assets/script'))
    .pipe(livereload())
})

gulp.task('script', function() {
  return gulp.src('src/assets/**/*.js')
    .pipe(uglify())
    .pipe(gulp.dest('src/assets'))
    .pipe(livereload())
})

gulp.task('clean', function() {
  del('dist/**/*.*')
})

gulp.task('default', ['clean'], function() {
  gulp.start('jade', 'stylus', 'coffee', 'script')
})

gulp.task('watch', function() {
  gulp.watch('src/jade/**/*.jade', ['jade'])
  gulp.watch('src/stylus/**/*.styl', ['stylus'])
  gulp.watch('src/coffee/**/*.coffee', ['coffee'])
  gulp.watch('src/**/*.js', ['script'])

  livereload.listen()
})
