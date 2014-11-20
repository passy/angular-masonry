/*!
 * angular-masonry <%= pkg.version %>
 * Pascal Hartig, weluse GmbH, http://weluse.de/
 * License: MIT
 */
(function () {
  'use strict';

  var loadedjQuery = typeof jQuery !== 'undefined';
  angular.module('wu.masonry', [])
    .controller('MasonryCtrl', function controller($scope, $element, $timeout) {
      var bricks = {};
      var schedule = [];
      var destroyed = false;
      var self = this;
      var timeout = null;

      this.preserveOrder = false;
      this.loadImages = true;
      this.masonry = null;

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
          if (loadedjQuery) {
            schedule.forEach(function scheduleForEach(args) {
              $element.masonry.apply($element, args);
            });
          } else {
            schedule.forEach(function scheduleForEach(args) {
              for (var i=0,n=args.length;i<n;i++) {
                self.masonry[args[i]]();
              }
            });
          }
          schedule = [];
        }, 30);
      };

      function defaultLoaded($element) {
        $element.addClass('loaded');
      }

      this.appendBrick = function appendBrick(element, id) {
        if (destroyed) {
          return;
        }

        function _append() {
          if (Object.keys(bricks).length === 0) {
            if (loadedjQuery) {
              $element.masonry('resize');
            } else {
              self.masonry.resize();
            }
          }
          if (bricks[id] === undefined) {
            // Keep track of added elements.
            bricks[id] = true;
            defaultLoaded(element);
            if (loadedjQuery) {
              $element.masonry('appended', element, true);
            } else {
              self.masonry.appended(element, true);
            }
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
          _append();
          _layout();
        } else if (self.preserveOrder) {
          _append();
          if (loadedjQuery) {
            element.imagesLoaded(_layout);
          } else {
            imagesLoaded(element[0], _layout);
          }
        } else {
          if (loadedjQuery) {
            element.imagesLoaded(function imagesLoaded() {
              _append();
              _layout();
            });
          } else {
            imagesLoaded(element[0], function imagesLoaded() {
              _append();
              _layout();
            });
          }
        }
      };

      this.removeBrick = function removeBrick(id, element) {
        if (destroyed) {
          return;
        }

        delete bricks[id];

        if (loadedjQuery) {
          $element.masonry('remove', element);
        } else {
          self.masonry.remove(element);
        }
        this.scheduleMasonryOnce('layout');
      };

      this.destroy = function destroy() {
        destroyed = true;

        if ($element.data('masonry')) {
          // Gently uninitialize if still present
          if (loadedjQuery) {
            $element.masonry('destroy');
          } else {
            self.masonry.destroy();
          }
        }
        $scope.$emit('masonry.destroyed');

        bricks = [];
      };

      this.reload = function reload() {
        if (loadedjQuery) {
          $element.masonry();
        } else {
          self.masonry($element[0]);
        }
        $scope.$emit('masonry.reloaded');
      };


    }).directive('masonry', function masonryDirective() {
      return {
        restrict: 'AE',
        controller: 'MasonryCtrl',
        link: {
          pre: function preLink(scope, element, attrs, ctrl) {
            var attrOptions = scope.$eval(attrs.masonry || attrs.masonryOptions);
            var options = angular.extend({
              itemSelector: attrs.itemSelector || '.masonry-brick',
              columnWidth: parseInt(attrs.columnWidth, 10) || attrs.columnWidth
            }, attrOptions || {});
            if (loadedjQuery) {
              element.masonry(options);
            } else {
              ctrl.masonry = new Masonry(element[0], options);
            }
            var loadImages = scope.$eval(attrs.loadImages);
            ctrl.loadImages = loadImages !== false;
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

            ctrl.appendBrick(element, id);
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