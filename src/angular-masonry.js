/**
 * angular-masonry
 *
 * @external 'angular.module'
 * @version <%= pkg.version %>
 * @author {@link https://passy.me/|Pascal Hartig}
 * @license: MIT
 */
(function () {
  'use strict';

  angular.module('wu.masonry', [])
    .controller('MasonryCtrl', function controller($scope, $element, $timeout) {
      var bricks = {};
      var schedule = [];
      var destroyed = false;
      var self = this;
      var timeout = null;

      this.preserveOrder = false;
      this.loadImages = false;

      this.scheduleMasonryOnce = function scheduleMasonryOnce() {
        var args = arguments;
        var found = schedule.filter(function filterFn(item) {
          return item[0] === args[0];
        }).length > 0;

        if (!found) {
          this.scheduleMasonry.apply(null, arguments);
        }
      };

      // Make sure it's only executed once within a reasonable time-frame in
      // case multiple elements are removed or added at once.
      this.scheduleMasonry = function scheduleMasonry() {
        if (timeout) {
          $timeout.cancel(timeout);
        }

        schedule.push([].slice.call(arguments));

        timeout = $timeout(function runMasonry() {
          if (destroyed) {
            return;
          }
          schedule.forEach(function scheduleForEach(args) {
            var method = args[0];
            args = args.slice(1);

            self.masonry[method].apply(self.masonry, args);
          });
          schedule = [];
        }, 30);
      };

      function defaultLoaded($element) {
        $element.addClass('loaded');
      }

      this.addBrick = function addBrick(method, element, id) {
        if (destroyed) {
          return;
        }

        function _add() {
          if (Object.keys(bricks).length === 0) {
            self.masonry.resize();
          }
          if (bricks[id] === undefined) {
            // Keep track of added elements.
            bricks[id] = true;
            defaultLoaded(element);
            self.masonry[method](element, true);
          }
        }

        function _layout() {
          // I wanted to make this dynamic but ran into huuuge memory leaks
          // that I couldn't fix. If you know how to dynamically add a
          // callback so one could say <masonry loaded="callback($element)">
          // please submit a pull request!
          self.scheduleMasonryOnce('layout');
        }

        if (!self.loadImages){
          _add();
          _layout();
        } else if (self.preserveOrder) {
          _add();
          window.imagesLoaded(element, _layout);
        } else {
          window.imagesLoaded(element, function imagesLoaded() {
            _add();
            _layout();
          });
        }
      };

      this.removeBrick = function removeBrick(id, element) {
        if (destroyed) {
          return;
        }

        delete bricks[id];
        self.masonry.remove(element);
        this.scheduleMasonryOnce('layout');
      };

      this.destroy = function destroy() {
        destroyed = true;

        if ($element.data('masonry')) {
          // Gently uninitialize if still present
          self.masonry.destroy();
        }
        $scope.$emit('masonry.destroyed');

        bricks = {};
      };

      this.reload = function reload() {
        self.masonry.reload();
        $scope.$emit('masonry.reloaded');
      };


    }).directive('masonry', function masonryDirective() {
      return {
        restrict: 'A',
        controller: 'MasonryCtrl',
        controllerAs: 'msnry',
        link: {
          pre: function preLink(scope, element, attrs, ctrl) {
            var attrOptions = scope.$eval(attrs.masonry || attrs.masonryOptions);
            var options = angular.extend({
              itemSelector: attrs.itemSelector || '.masonry-brick',
              columnWidth: parseInt(attrs.columnWidth, 10) || attrs.columnWidth
            }, attrOptions || {});

            scope.masonryContainer = element[0];
            ctrl.masonry = new Masonry(scope.masonryContainer, options);

            var loadImages = scope.$eval(attrs.loadImages);
            ctrl.loadImages = !!loadImages;

            var preserveOrder = scope.$eval(attrs.preserveOrder);
            ctrl.preserveOrder = (preserveOrder !== false && attrs.preserveOrder !== undefined);

            var reloadOnShow = scope.$eval(attrs.reloadOnShow);

            if (reloadOnShow !== false && attrs.reloadOnShow !== undefined) {
              scope.$watch(function () {
                return element.prop('offsetParent');
              }, function (isVisible, wasVisible) {
                if (isVisible && !wasVisible) {
                  ctrl.reload();
                }
              });
            }

            var reloadOnResize = scope.$eval(attrs.reloadOnResize);
            if (reloadOnResize !== false && attrs.reloadOnResize !== undefined) {
              scope.$watch('masonryContainer.offsetWidth', function (newWidth, oldWidth) {
                if (newWidth !== oldWidth) {
                  ctrl.reload();
                }
              });
            }

            scope.$emit('masonry.created', element);
            scope.$on('$destroy', ctrl.destroy);
          }
        }
      };
    }).directive('masonryBrick', function masonryBrickDirective() {
      return {
        restrict: 'AC',
        require: '^masonry',
        scope: true,
        link: {
          pre: function preLink(scope, element, attrs, ctrl) {
            var id = scope.$id, index;
            var prependBrick = scope.$eval(attrs.prepend);
            var method = prependBrick ? 'prepended' : 'appended';

            ctrl.addBrick(method, element, id);
            element.on('$destroy', function () {
              ctrl.removeBrick(id, element);
            });

            scope.$on('masonry.reload', function () {
              ctrl.scheduleMasonryOnce('reloadItems');
              ctrl.scheduleMasonryOnce('layout');
            });

            scope.$watch('$index', function () {
              if (index !== undefined && index !== scope.$index) {
                ctrl.scheduleMasonryOnce('reloadItems');
                ctrl.scheduleMasonryOnce('layout');
              }
              index = scope.$index;
            });
          }
        }
      };
    });
}());
