const gulp = require('gulp');
const sass = require('gulp-sass')(require('sass'));

gulp.task('sass', ()=> {
    return gulp.src('src/sass/**/*.scss')
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest('src/css/'))
});