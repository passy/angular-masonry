/**
 * angular-masonry v0.0.1
 * Pascal Hartig, weluse GmbH, http://weluse.de/
 * License: MIT
 */
(function () {
  'use strict';

  angular.module('wu.masonry', [])
    .directive('masonry', function ($timeout) {
      return {
        restrict: 'AE',

        link: function postLink(scope, element, attrs) {
          var itemSelector = attrs.itemSelector || '.masonry-brick';
          element.masonry({ itemSelector: itemSelector });
        },

        controller: function controller($scope, $element) {
          var bricks = {};
          var reloadScheduled = false;

          // Make sure it's only executed once within a reasonable time-frame in
          // case multiple elements are removed or added at once.
          function scheduleReload() {
            if (!reloadScheduled) {
              reloadScheduled = true;

              $timeout(function () {
                reloadScheduled = false;
                $element.masonry('layout');
              }, 0);
            }
          }

          this.appendBrick = function (element, id, wait) {
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

          this.removeBrick = function (id, element) {
            delete bricks[id];
            $element.masonry('remove', element);

            scheduleReload();
          };
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
