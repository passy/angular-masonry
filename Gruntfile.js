module.exports = function (grunt) {

    var banner = '/**\n    @name: <%= pkg.name %> \n    @version: <%= pkg.version %> (<%= grunt.template.today("dd-mm-yyyy") %>) \n    @url: <%= pkg.homepage %> \n    @license: <%= pkg.license %>\n*/\n';

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        uglify: {
            js: {
                files: {
                    'dist/angular-masonry-packed.min.js': [
                        'node_modules/jquery-bridget/jquery.bridget.js',
                        'node_modules/get-style-property/get-style-property.js',
                        'node_modules/get-size/get-size.js',
                        'node_modules/eventEmitter/EventEmitter.js',
                        'node_modules/eventie/eventie.js',
                        'node_modules/doc-ready/doc-ready.js',
                        'node_modules/matches-selector/matches-selector.js',
                        'node_modules/fizzy-ui-utils/utils.js',
                        'node_modules/outlayer/item.js',
                        'node_modules/outlayer/outlayer.js',
                        'node_modules/masonry/masonry.js',
                        'node_modules/imagesloaded/imagesloaded.js',
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
                        'node_modules/jquery-bridget/jquery.bridget.js',
                        'node_modules/get-style-property/get-style-property.js',
                        'node_modules/get-size/get-size.js',
                        'node_modules/eventEmitter/EventEmitter.js',
                        'node_modules/eventie/eventie.js',
                        'node_modules/doc-ready/doc-ready.js',
                        'node_modules/matches-selector/matches-selector.js',
                        'node_modules/fizzy-ui-utils/utils.js',
                        'node_modules/outlayer/item.js',
                        'node_modules/outlayer/outlayer.js',
                        'node_modules/masonry/masonry.js',
                        'node_modules/imagesloaded/imagesloaded.js',
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