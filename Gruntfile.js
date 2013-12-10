module.exports = function (grunt) {
  'use strict';

  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    pkg: grunt.file.readJSON('bower.json'),
    uglify: {
      options: {
        preserveComments: 'some'
      },
      dist: {
        src: '<%= pkg.name %>.js',
        dest: '<%= pkg.name %>.min.js'
      }
    },
    concat: {
      options: {
        process: true
      },
      dist: {
        src: 'src/<%= pkg.name %>.js',
        dest: '<%= pkg.name %>.js'
      }
    },
    karma: {
      dist: {
        configFile: 'karma.conf.js',
        browsers: ['PhantomJS']
      },
      watch: {
        configFile: 'karma.conf.js',
        singleRun: false,
        autoWatch: true
      }
    },
    changelog: {
      options: {
        github: 'passy/angular-masonry'
      }
    },
    ngmin: {
      dist: {
        src: '<%= pkg.name %>.js',
        dest: '<%= pkg.name %>.js'
      }
    }
  });

  grunt.registerTask('default', ['concat', 'ngmin', 'uglify']);
  grunt.registerTask('test', ['karma:dist']);
};
