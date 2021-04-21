//common
const gulp = require("gulp");
const sourcemaps = require("gulp-sourcemaps");
const iff = require("gulp-if");
const ftp = require("vinyl-ftp");
const rename = require("gulp-rename");
const debug = require("gulp-debug");
const URL = require("url").URL;
const path = require("path");
const fs = require("fs");

//scripts
const uglify = require("gulp-uglify");
const concat = require("gulp-concat");

//css
const less = require("gulp-less");
const replace = require("gulp-replace");
const autoprefixer = require("gulp-autoprefixer");
const cleanCSS = require("gulp-clean-css");

//images
const imagemin = require("gulp-imagemin");
const imageminJpegRecompress = require("imagemin-jpeg-recompress");

//svg
const svgmin = require("gulp-svgmin");
const svgstore = require("gulp-svgstore");

//fonts
var fontello = require("gulp-fontello");

const ID = "express";
//command line arguments
var options = {
  dist: false,
  debug: process.env.DEBUG,
  watching: false,
  ftp: process.env.FTP_URL
};

const paths = {
  scripts: {
    src: [
      `node_modules/cash-dom/dist/cash.js`,
      "js/drs.js"
    ],
    outfile: `drs.min.js`,
    dest: "js/",
    dist: "/sam-drs/js"
  },
  polyfills: {
    "src": [
      "node_modules/picturefill/dist/picturefill.js",
      "node_modules/svg4everybody/dist/svg4everybody.js",
      "node_modules/smoothscroll-polyfill/dist/smoothscroll.js",
      "node_modules/dialog-polyfill/dialog-polyfill.js",
      "js/polyfills.js"
    ],
    "outfile": "polyfills.min.js",
    "dest": "js/",
    "dist": "/sam-drs/js"
  },
  otherScripts: {
    src: [
      "js/modernizr.js",
      "js/sam.js"
    ],
    dest: "js/",
    dist: "/sam-drs/js"
  },
  styles: {
    src: [`css/drs.css`, `css/drs/drs.user.less`],
    inc: ["node_modules/normalize.css/normalize.css"],
    dest: "css/",
    dist: "/sam-drs/css"
  },
  images: {
    src: "images/**/*.{png,jpg,jpeg,gif,svg,webp,json,xml,ico}",
    dest: "images",
    dist: "/sam-drs/images"
  },
  "inline-images": {
    src: "content/inline-images/**/*.{png,jpg,jpeg,gif,svg,webp}",
    dest: "content/inline-images/",
    dist: "/sam-drs/content/inline-images"
  },
  templates: {
    src: "page-templates/**/*.{xsl,html,json}",
    dist: `/sam-drs/page-templates`
  },
  custom: {
    src: "custom/**",
    dist: "/sam-drs/custom/"
  },
  includes: {
    src: "content/includes/**",
    dist: "/sam-drs/content/includes/"
  },
  fonts: {
    src: "fontello/config.json",
    dest: "fonts/icon-fonts/",
    dist: "/sam-drs/fonts/icon-fonts"
  }
};

let conn;

if (options.ftp) {
  const { username, password, host, protocol } = new URL(options.ftp);
  conn = ftp.create({
    host: host,
    user: username,
    password: password,
    parallel: 5,
    secure: protocol === "ftps:",
    secureOptions: {
      rejectUnauthorized: false
    },
    // log: console.log,
    debug: function debug(data) {
      if (options.debug) {
        console.log(data);
      } else {
        return false;
      }
    }
  });
}

function dist(callback) {
  options.dist = true;
  callback();
}

function styles() {
  const path = paths.styles;

  return gulp
    .src(path.src)
    .pipe(sourcemaps.init())
    .pipe(less())
    .pipe(
      autoprefixer({
        browsers: ["ie >= 9", "ff > 4", "Safari > 4", "Chrome > 20"]
      })
    )
    .pipe(cleanCSS())
    .pipe(replace("../fonts/" + ID, "/fonts/" + ID))
    .pipe(replace("../font/", "/fonts/icon-fonts/font/"))
    .pipe(
      iff(
        !options.dist,
        rename(function(pathObj) {
          pathObj.basename += ".min";
        })
      )
    )
    .pipe(sourcemaps.write("."))
    .pipe(
      iff(options.dist && conn, conn.dest(path.dist), gulp.dest(path.dest))
    );
}

function scripts() {
  return doScripts("scripts", true);
}

function polyfills() {
  return doScripts("polyfills");
}

function otherScripts() {
  return doScripts("otherScripts");
}

function doScripts(type, maps) {
  const path = paths[type];
  const outfile = path.outfile;

  let stream = gulp.src(path.src)
    .pipe(debug())
    .pipe(iff(!!maps, sourcemaps.init()));

  if (!!outfile) {
    // Concat to the specified output file name.
    stream = stream.pipe(concat(path.outfile))
  }

  stream = stream.pipe(uglify());

  if (!outfile) {
    // Suffix the filename with .min if no specified outfile.
    stream = stream.pipe(rename(function(pathObj) {
      pathObj.basename += ".min";
    }));
  }

  return stream
    .pipe(iff(!!maps, sourcemaps.write(".")))
    .pipe(iff(options.dist && conn, conn.dest(path.dist), gulp.dest(path.dest)));
}

const imageminPlugins = [
  imagemin.gifsicle({ interlaced: true }),
  imageminJpegRecompress({
    progressive: true,
    max: 80,
    min: 70
  }),
  imagemin.optipng({ optimizationLevel: 5 }),
  imagemin.svgo({
    plugins: [{ cleanupIDs: false }, { removeUselessDefs: false }]
  })
];

function images() {
  const path = paths.images;

  return gulp
    .src(path.src, { since: gulp.lastRun(images) })
    .pipe(imagemin(imageminPlugins, { verbose: true }))
    .pipe(iff(options.dist && conn, conn.dest(path.dist)));
}

function inlineImages(done) {
  const path = paths["inline-images"];

  return gulp
    .src(path.src, { since: gulp.lastRun(inlineImages) })
    .pipe(imagemin(imageminPlugins, { verbose: true }))
    .pipe(iff(options.dist && conn, conn.dest(path.dist)));
}

function templates() {
  const path = paths.templates;

  return gulp
    .src(path.src)
    .pipe(iff(options.dist && conn, conn.dest(path.dist)))
    .on("error", function(err) {
      console.log(err);
    });
}

function fonts() {
  const path = paths.fonts;

  return gulp
    .src(path.src)
    .pipe(fontello())
    .pipe(
      iff(options.dist && conn, conn.dest(path.dist), gulp.dest(path.dest))
    );
}

// gulp.task("fonts", function buildFonts() {
//   return gulp.src("fontello/config.json")
//     .pipe(fontello())
//     .pipe(gulp.dest("fonts/pioneer/icon-font/"))
//     .pipe(conn.dest("/sam/fonts/pioneer/icon-font/"));
// });

function custom() {
  const path = paths.custom;

  return gulp
    .src(path.src, { since: gulp.lastRun(custom) })
    .pipe(iff(options.dist && conn, conn.dest(path.dist)));
}

function watch() {
  options.watching = true;
  gulp.watch(paths.scripts.src, scripts);
  gulp.watch(paths.polyfills.src, polyfills);
  gulp.watch(paths.otherScripts.src, otherScripts);
  gulp.watch("css/**/*.(less)", styles);
  gulp.watch(paths.images.src, images);
  gulp.watch(paths["inline-images"].src, inlineImages);
  gulp.watch(paths.templates.src, templates);
  gulp.watch(paths.custom.src, custom);
}

const allScripts = gulp.parallel(scripts, polyfills, otherScripts);

const build = gulp.parallel(
  styles,
  allScripts,
  images,
  fonts,
  // custom,
  templates
);

gulp.task("dist", dist);
gulp.task("styles", styles);
gulp.task("scripts", allScripts);
gulp.task("templates", templates);
gulp.task("build", build);
gulp.task("deploy", gulp.series(dist, build));
gulp.task("watch", watch);
gulp.task("fonts", fonts);

gulp.task("default", build);

// SAM Jr.'s hook on file events.
module.exports = function transform(event, fullpath) {
  const url = new URL("http://localhost:9999" + fullpath);
  // Remove querystring.
  fullpath = url.pathname;

  if (event === "request") {
    // Do something here, i.e., compile LESS into CSS. If this function
    // returns body string, it will be returned to browser.

    if (fullpath.indexOf("/admin/") === -1 && /\.css$/.test(fullpath)) {
      // Post process CSS files.
      const filename = `${path.basename(fullpath, ".css")}.css`;
      const styles = fs.readFileSync(`./css/${filename}`, "utf8");
      return require("less")
        .render(styles, {
          paths: [".", "./css"], // Specify search paths for @import directives
          filename: filename
        })
        .then(function(output) {
          return output.css;
        }, console.error);
    }
  }
};
