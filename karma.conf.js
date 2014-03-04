module.exports = function (config) {
  'use strict';

  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    files: [
      'bower_components/jquery/jquery.js',
      'bower_components/sinonjs/sinon.js',
      'bower_components/jasmine-sinon/lib/jasmine-sinon.js',
      'bower_components/angular/angular.js',
      'bower_components/angular-mocks/angular-mocks.js',
      'bower_components/get-style-property/get-style-property.js',
      'bower_components/get-size/get-size.js',
      'bower_components/eventEmitter/EventEmitter.js',
      'bower_components/eventie/eventie.js',
      'bower_components/doc-ready/doc-ready.js',
      'bower_components/matches-selector/matches-selector.js',
      'bower_components/outlayer/item.js',
      'bower_components/outlayer/outlayer.js',
      'bower_components/masonry/masonry.js',
      'bower_components/imagesloaded/imagesloaded.js',
      'src/angular-masonry.js',
      'test/mocks/**/*.js',
      'test/spec/**/*.coffee'
    ],
    exclude: [],
    reporters: ['dots'],
    autoWatch: false,
    browsers: ['Chrome'],
    captureTimeout: 5000,
    singleRun: true,
    reportSlowerThan: 100
  });
};
