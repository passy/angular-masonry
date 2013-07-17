/*!
 * angular-masonry 0.2.0
 * Pascal Hartig, weluse GmbH, http://weluse.de/
 * License: MIT
 */
(function () {
  'use strict';

  angular.module('wu.masonry', [])
    .controller('MasonryCtrl', function controller($scope, $element, $timeout) {
      var bricks = {};
      var reloadScheduled = false;
      var destroyed = false;

      // Make sure it's only executed once within a reasonable time-frame in
      // case multiple elements are removed or added at once.
      function scheduleReload() {
        if (!reloadScheduled) {
          reloadScheduled = true;

          $timeout(function relayout() {
            reloadScheduled = false;
            $element.masonry('layout');
          }, 0);
        }
      }

      function defaultLoaded($element) {
        $element.addClass('loaded');
      }

      this.appendBrick = function appendBrick(element, id) {
        if (destroyed) {
          return;
        }

        function _append() {
          if (Object.keys(bricks).length === 0) {
            // Call masonry asynchronously on initialization.
            $timeout(function () {
              $element.masonry('resize');
            });
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
            scheduleReload();
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

        scheduleReload();
      };

      this.destroy = function destroy() {
        destroyed = true;

        if ($element.data('masonry')) {
          // Gently uninitialize if still present
          $element.masonry('destroy');
        }

        bricks = [];
      };

    }).directive('masonry', function () {
      return {
        restrict: 'AE',
        controller: 'MasonryCtrl',
        link: function postLink(scope, element, attrs, ctrl) {
          var attrOptions = scope.$eval(attrs.options);
          var options = angular.extend(attrOptions || {}, {
            itemSelector: attrs.itemSelector || '.masonry-brick',
            columnWidth: attrs.columnWidth
          });
          element.masonry(options);

          scope.$on('$destroy', ctrl.destroy);
        }
      };
    }).directive('masonryBrick', function () {
      return {
        restrict: 'AC',
        require: '^masonry',
        link: function postLink(scope, element, attrs, ctrl) {
          var id = scope.$id;

          ctrl.appendBrick(element, id);
          scope.$on('$destroy', function () {
            ctrl.removeBrick(id, element);
          });
        }
      };
    });
}());
