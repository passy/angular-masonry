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
      var reloadScheduled = false;

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

      this.appendBrick = function appendBrick(element, id, wait) {
        function _append() {
          if (Object.keys(bricks).length === 0) {
            // Call masonry asynchronously on initialization.
            $timeout(function () {
              $element.masonry('resize');
            });
          }

          element.addClass('loaded');
          if (bricks[id] === undefined) {
            // Keep track of added elements.
            bricks[id] = true;
            $element.masonry('appended', element, true);
            scheduleReload();
          }
        }

        if (wait) {
          element.imagesLoaded(_append);
        } else {
          _append();
        }
      };

      this.removeBrick = function removeBrick(id, element) {
        delete bricks[id];
        $element.masonry('remove', element);

        scheduleReload();
      };
    }).directive('masonry', function () {
      return {
        restrict: 'AE',
        controller: 'MasonryCtrl',
        link: function postLink(scope, element, attrs) {
          var itemSelector = attrs.itemSelector || '.masonry-brick';
          element.masonry({ itemSelector: itemSelector });
        }
      };
    }).directive('masonryBrick', function () {
      return {
        restrict: 'AC',
        require: '^masonry',
        link: function postLink(scope, element, attrs, ctrl) {
          var id = scope.$id;
          ctrl.appendBrick(element, id, true);

          scope.$on('$destroy', function () {
            ctrl.removeBrick(id, element);
          });
        }
      };
    });
}());
