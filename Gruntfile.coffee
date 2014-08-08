path = require 'path'

module.exports = (grunt) ->

  globalConfig =
    src: 'src'
    pub: 'pub/client'

  buildDir = 'pub'
  clientBuildDir = path.join(buildDir, 'client')
  imgBuildDir = path.join(clientBuildDir, 'img')
  jsBuildDir = path.join(clientBuildDir, 'js')
  cssBuildDir = path.join(clientBuildDir, 'css')
  viewsBuildDir = path.join(clientBuildDir, 'views')
  mainJsBuildPath = path.join(jsBuildDir, 'main.js')
  configJsBuildPath = path.join(jsBuildDir, 'config.js')
  classesJsBuildPath = path.join(jsBuildDir, 'classes.js')
  controllersJsBuildPath = path.join(jsBuildDir, 'controllers.js')
  servicesJsBuildPath = path.join(jsBuildDir, 'services.js')
  bowerJsBuildPath = path.join(jsBuildDir, 'bower.js')

  grunt.initConfig
    globalConfig: globalConfig
    pkg: grunt.file.readJSON('package.json')
    clean:
      options:
        force: true
      client: [path.join(clientBuildDir, '**')]
    coffeelint:
      options:
        max_line_length:
          level: 'ignore'
        no_trailing_whitespace:
          level: 'ignore'
      client: ['src/**/*.coffee']
    coffee:
      client:
        options:
          bare: true
        files: [
          '<%= globalConfig.pub %>/js/main.js':         ['<%= globalConfig.src %>/scripts/main.coffee'],
          '<%= globalConfig.pub %>/js/classes.js':      ['<%= globalConfig.src %>/scripts/classes/**/*.coffee'],
          '<%= globalConfig.pub %>/js/controllers.js':  ['<%= globalConfig.src %>/scripts/controllers/**/*.coffee'],
          '<%= globalConfig.pub %>/js/services.js':     ['<%= globalConfig.src %>/scripts/services/**/*.coffee']
        ]
    copy:
      client:
        files: [
          # copy the image files
          {expand: true, flatten: true, src: ['<%= globalConfig.src %>/images/**'], dest: imgBuildDir},
          # copy all CSS files
          # we are not currently publishing the icon fonts
          {expand: true, flatten: true, src: ['<%= globalConfig.src %>/stylesheets/**/*.css'], dest: cssBuildDir}
        ]
    jade:
      options:
        pretty: false
        # client: true
      client:
        files: [
          {expand: true, flatten: true, src: ['src/views/**/*.jade', '!src/views/base.jade'], dest: '<%= globalConfig.pub %>', ext: '.html'}
        ]
    bower_concat:
      all:
        dest: bowerJsBuildPath
        dependencies:
          'angular': ['jquery'] # we can fake this dependency to make sure it loads jquery BEFORE angular
          'angular-animate': ['angular']
          'angular-route': ['angular']
          'angular-bootstrap': ['angular']
          'angular-ui-select2': ['angular', 'select2', 'jquery']
          'angular-ui-calendar': ['angular', 'jquery', 'fullcalendar']
          'bootstrap': ['jquery']
          'jquery': []
          'lodash': []
          'chartjs': []
          'jquery-ui': ['jquery']
          'fullcalendar': ['jquery', 'moment']
          'select2': ['jquery']
          'moment': []

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-bower-concat'

  create_client_pub_dirs = () ->
    grunt.file.mkdir clientBuildDir
    grunt.file.mkdir imgBuildDir
    grunt.file.mkdir jsBuildDir
    grunt.file.mkdir cssBuildDir

  create_server_pub_dirs = () ->
    grunt.file.mkdir serverBuildDir

  create_log_dirs = () ->
    logDir = 'logs'
    grunt.file.mkdir(logDir) if !grunt.file.exists(logDir)

  grunt.registerTask 'default', 'clean, build, and test all code', () ->
    grunt.task.run ['dist', 'test']

  ###############
  ### Deploy  ###
  ###############

  grunt.registerTask 'dist', 'clean and build all code', () ->
    grunt.task.run ['clean:client']
    create_client_pub_dirs()
    create_log_dirs()
    grunt.task.run ['coffeelint:client', 'coffee:client', 'jade:client', 'copy:client', 'bower_concat:all']

  ###############
  ### TESTING ###
  ###############
  grunt.registerTask 'test', 'test all code', () ->
    grunt.log.write 'nothing to do yet...'