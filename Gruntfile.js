module.exports = function (grunt) {
  'use strict';

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
        src: 'src/<%= pkg.name %>.min.js',
        dest: '<%= pkg.name %>.js'
      }
    },
    karma: {
      dist: {
        configFile: 'karma.conf.js'
      },
      watch: {
        configFile: 'karma.conf.js',
        singleRun: false,
        autoWatch: true
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-karma');
  grunt.registerTask('default', ['concat', 'uglify']);
  grunt.registerTask('test', ['karma:dist']);
};
