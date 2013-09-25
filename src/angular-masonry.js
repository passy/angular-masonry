/*!
 * angular-masonry <%= pkg.version %>
 * Pascal Hartig, weluse GmbH, http://weluse.de/
 * License: MIT
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

      this.scheduleMasonryOnce = function scheduleMasonryOnce() {
        var args = arguments;
        var found = schedule.filter(function (item) {
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
          schedule.forEach(function (args) {
            $element.masonry.apply($element, args);
          });
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
            $element.masonry('resize');
          }

          if (bricks[id] === undefined) {
            // I wanted to make this dynamic but ran into huuuge memory leaks
            // that I couldn't fix. If you know how to dynamically add a
            // callback so one could say <masonry loaded="callback($element)">
            // please submit a pull request!
            defaultLoaded(element);

            // Keep track of added elements.
            bricks[id] = true;
            $element.masonry('appended', element, true);
            self.scheduleMasonryOnce('layout');
          }
        }

        element.imagesLoaded(_append);
      };

      this.removeBrick = function removeBrick(id, element) {
        if (destroyed) {
          return;
        }

        delete bricks[id];
        $element.masonry('remove', element);
        this.scheduleMasonryOnce('layout');
      };

      this.destroy = function destroy() {
        destroyed = true;

        if ($element.data('masonry')) {
          // Gently uninitialize if still present
          $element.masonry('destroy');
        }
        $scope.$emit('masonry.destroyed');

        bricks = [];
      };

      this.reload = function reload() {
            $element.masonry();
              $scope.$emit('masonry.reloaded');

      };


    }).directive('masonry', function () {
      return {
        restrict: 'AE',
        controller: 'MasonryCtrl',
        link: {
          pre: function preLink(scope, element, attrs, ctrl) {
            var attrOptions = scope.$eval(attrs.masonry || attrs.masonryOptions);
            var options = angular.extend(attrOptions || {}, {
              itemSelector: attrs.itemSelector || '.masonry-brick',
              columnWidth: parseInt(attrs.columnWidth, 10)
            });
            element.masonry(options);

            scope.$emit('masonry.created', element);
            scope.$on('$destroy', ctrl.destroy);
          }
        }
      };
    }).directive('masonryBrick', function () {
      return {
        restrict: 'AC',
        require: '^masonry',
        scope: true,
        link: {
          pre: function preLink(scope, element, attrs, ctrl) {
            var id = scope.$id;

            ctrl.appendBrick(element, id);
            element.on('$destroy', function () {
              ctrl.removeBrick(id, element);
            });
            
            scope.$on('masonry.reload', function () {
              ctrl.reload();
            });

          }
        }
      };
    });
}());
