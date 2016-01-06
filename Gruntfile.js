module.exports = function (grunt) {

    var banner = '/**\n    @name: <%= pkg.name %> \n    @version: <%= pkg.version %> (<%= grunt.template.today("dd-mm-yyyy") %>) \n    @url: <%= pkg.homepage %> \n    @license: <%= pkg.license %>\n*/\n';

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        uglify: {
            js: {
                files: {
                    'dist/angular-masonry-packed.min.js': [
                        'bower_components/jquery-bridget/jquery.bridget.js',
                        'bower_components/get-style-property/get-style-property.js',
                        'bower_components/get-size/get-size.js',
                        'bower_components/eventEmitter/EventEmitter.js',
                        'bower_components/eventie/eventie.js',
                        'bower_components/doc-ready/doc-ready.js',
                        'bower_components/matches-selector/matches-selector.js',
                        'bower_components/fizzy-ui-utils/utils.js',
                        'bower_components/outlayer/item.js',
                        'bower_components/outlayer/outlayer.js',
                        'bower_components/masonry/masonry.js',
                        'bower_components/imagesloaded/imagesloaded.js',
                        'src/*.js'
                    ]
                }
            },
            options: {
                banner: banner,
            }
        },
        concat: {
            options: {
                separator: ';',
                banner: banner,
            },
            dist: {
                files: {
                    'dist/angular-masonry-packed.js': [
                        'bower_components/jquery-bridget/jquery.bridget.js',
                        'bower_components/get-style-property/get-style-property.js',
                        'bower_components/get-size/get-size.js',
                        'bower_components/eventEmitter/EventEmitter.js',
                        'bower_components/eventie/eventie.js',
                        'bower_components/doc-ready/doc-ready.js',
                        'bower_components/matches-selector/matches-selector.js',
                        'bower_components/fizzy-ui-utils/utils.js',
                        'bower_components/outlayer/item.js',
                        'bower_components/outlayer/outlayer.js',
                        'bower_components/masonry/masonry.js',
                        'bower_components/imagesloaded/imagesloaded.js',
                        'src/*.js'
                    ]
                }
            },
        },
        watch: {
            minifiyJs: {
                files: [
                    'src/*.js'
                ],
                tasks: ['uglify', 'concat'],
                options: {
                    spawn: true,
                },
            },
        },
    });

    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.registerTask('default', ['watch']);

};