module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    coffee:
      compile:
        options:
            bare: true
        files:
          'app/angular/angular-app.js': [
              'app/angular/app.coffee'
              'app/angular/controllers.coffee'
              'app/angular/directives.coffee'
              'app/angular/filters.coffee'
              'app/angular/services.coffee'
          ]

    uglify:
      options:
        banner: "/*! <%= pkg.name %> <%= pkg.version %> */\n"

      dist:
        src: 'app/angular/angular-app.js'
        dest: 'public/angular-app.min.js'


  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'default', ['coffee', 'uglify']
  grunt.registerTask 'heroku', ['coffee', 'uglify']
