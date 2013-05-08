module.exports = ->

  SRC_DIR = 'src/'
  TESTS_DIR = 'tests/'
  SPEC_DIR = TESTS_DIR + 'spec/'
  DIST_DIR = 'dist/'

  CSS_DIR = SRC_DIR + 'css/'
  IMG_DIR = SRC_DIR + 'img/'
  LIB_DIR = SRC_DIR + 'lib/'

  @initConfig

    PKG: @file.readJSON('package.json')

    csslint:
      all:
        files:
          src: CSS_DIR + '*.css'

    jshint:
      gruntfile:
        src: ['Gruntfile.js']
        options:
          jshintrc: '.jshintrc'

      lib:
        src: [DIST_DIR + 'lib/!(output.min.js)']
        options:
          jshintrc: LIB_DIR + '.jshintrc'

      tests:
        src: [DIST_DIR + SPEC_DIR + '*.js']
        options:
          jshintrc: SRC_DIR + TESTS_DIR + '.jshintrc'

    coffee:
      compile:
        expand: true
        flatten: true
        cwd: LIB_DIR
        src: ['*.coffee']
        dest: DIST_DIR + 'lib/'
        ext: '.js'

      compileTests:
        expand: true
        flatten: true
        cwd: SRC_DIR + SPEC_DIR
        src: ['*.coffee']
        dest: DIST_DIR + SPEC_DIR
        ext: '.js'

    jasmine:
      test:
        src: [DIST_DIR + 'lib/!(*min.js)']
        options:
          specs: [DIST_DIR + SPEC_DIR + '*_spec.js']

    uglify:
      dest:
        files:
          'dist/lib/output.min.js': ['dist/lib/*.js']

    cssmin:
      options:
        report: 'gzip'
      minify:
        src: [CSS_DIR + '*.css']
        dest: DIST_DIR + 'css/style.min.css'

    watch:
      gruntfile:
        files: ['Gruntfile.coffee']
        tasks: ['jshint:gruntfile']

      lib:
        files: [LIB_DIR + '*.coffee']
        tasks: ['coffee:compile', 'jshint:lib']

      test:
        files: [SRC_DIR + SPEC_DIR + '*.coffee']
        tasks: ['coffee:compileTests', 'jshint:tests']

    clean: [DIST_DIR, '.grunt', '_SpecRunner.html']

    copy:
      main:
        files: [
          {expand: true, cwd: SRC_DIR, src: ['img/**', TESTS_DIR + 'SpecRunner.*', TESTS_DIR + 'lib/**', 'index.html'], dest: DIST_DIR}
        ]


  @loadNpmTasks 'grunt-contrib-coffee'
  @loadNpmTasks 'grunt-contrib-csslint'
  @loadNpmTasks 'grunt-contrib-cssmin'
  @loadNpmTasks 'grunt-contrib-watch'
  @loadNpmTasks 'grunt-contrib-jshint'
  @loadNpmTasks 'grunt-contrib-jasmine'
  @loadNpmTasks 'grunt-contrib-uglify'
  @loadNpmTasks 'grunt-contrib-clean'
  @loadNpmTasks 'grunt-contrib-copy'
  @loadNpmTasks 'grunt-karma'


  @registerTask 'default', ['coffee', 'style', 'test',]
  @registerTask 'dist', ['clean', 'coffee', 'copy', 'min']
  @registerTask 'build', ['default', 'dist']
  @registerTask 'test', ['jasmine']
  @registerTask 'style', ['jshint', 'csslint']
  @registerTask 'min', ['uglify', 'cssmin']
