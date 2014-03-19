module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON("package.json")
        coffee:
            options:
                bare: true
                sourceMap: true
            compileClient:
                files:
                    'app/angular/angular-app.js': [
                        'app/angular/app.coffee'
                        'app/angular/controllers.coffee'
                        'app/angular/directives.coffee'
                        'app/angular/filters.coffee'
                        'app/angular/services.coffee'
                    ]
            compileClientDev:
                expand: true
                src: ['app/angular/*.coffee']
                ext: '.js'

        uglify:
            options:
                banner: "/*! <%= pkg.name %> <%= pkg.version %> */\n"

            dist:
                files:
                    'public/angular-app.min.js': 'app/angular/angular-app.js'
                    # minifying x3dom saves ~150kb raw, but only 11 gzipped
#                    'public/lib/x3dom-1.5.1/x3dom.min.js': 'public/lib/x3dom-1.5.1/x3dom.js'
#                    'public/lib/x3dom-1.5.1/x3dom-full.min.js': 'public/lib/x3dom-1.5.1/x3dom-full.js'

        concat:
            options:
                separator: ';\n'
            dist:
                src: [
                    'public/lib/socket.io-client/dist/socket.io.min.js'
                    'public/lib/angular/angular.min.js'
                    'public/lib/angular-route/angular-route.min.js'
                    'public/lib/angular-resource/angular-resource.min.js'
                    'public/lib/angular-bootstrap/ui-bootstrap-tpls.min.js'
                    'public/lib/x3dom-1.5.1/x3dom.js'
                ]
                dest: 'public/lib/all-deps.js'

        nodemon:
            dev:
                script: 'app.coffee'

        watch:
            coffee:
                files: ['app/angular/*.coffee']
                # TODO!: why doesn't newer work correctly here?
                tasks: 'coffee:compileClientDev'

    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-nodemon'
    grunt.loadNpmTasks 'grunt-contrib-watch'
#    grunt.loadNpmTasks 'grunt-newer'

    grunt.registerTask 'default', ['coffee', 'uglify', 'concat']
    grunt.registerTask 'heroku', ['coffee', 'uglify', 'concat']

