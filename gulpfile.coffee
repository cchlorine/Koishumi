# Dependencies
del   = require 'del'
gulp  = require 'gulp'

concat = require 'gulp-concat'
rename = require 'gulp-rename'

jade   = require 'gulp-jade'
stylus = require 'gulp-stylus'
coffee = require 'gulp-coffee'

uglify       = require 'gulp-uglify'
autoprefixer = require 'gulp-autoprefixer'
minifycss    = require 'gulp-minify-css'

livereload = require 'gulp-livereload'

# Path
jadePath    = './src/jade'
stylusPath  = './src/stylus'
coffeePath  = './src/coffee'
assetsPath  = './src/assets'
distPath    = './dist'

# Task Jade
gulp.task 'jade', ->
    gulp.src jadePath + '/**/*.jade'
	   .pipe jade { pretty: false }
	   .pipe gulp.dest distPath
	   .pipe livereload()

# Task Stylus
gulp.task 'stylus', ->
    gulp.src stylusPath + '/main.styl'
        .pipe stylus()
        .pipe autoprefixer 'last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'
        .pipe minifycss()
        .pipe gulp.dest distPath + '/assets/style/'
        .pipe livereload()

# Task Coffee
gulp.task 'coffee', ->
    gulp.src coffeePath + '/**/*.coffee'
        .pipe coffee { bare: true }
        .pipe gulp.dest distPath + '/assets/script/'
        .pipe livereload()

# Task Assets
# Copy asseets to dist
gulp.task 'assets', ->
    gulp.src assetsPath + '/**/*'
        .pipe gulp.dest distPath + '/assets/'
        .pipe livereload()

# Task Clean
# Clean old files
gulp.task 'clean', ->
    del distPath + '**/*.*'

# Default
gulp.task 'default', ['clean'], ->
  gulp.start 'jade', 'stylus', 'coffee', 'assets'

# Task Watch
gulp.task 'watch', ->
    gulp.watch jadePath   + '/**/*.jade', ['jade']
    gulp.watch stylusPath + '/**/*.styl', ['stylus']
    gulp.watch coffeePath + '/**/*.coffee', ['coffee']
    gulp.watch assetsPath + '/**/*', ['assets']
    livereload.listen()