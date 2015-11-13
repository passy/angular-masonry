###!
# angular-masonrye <%= pkg.version %>
# Pascal Hartig
# License: MIT
###

do ->
  'use strict'
  angular.module('wu.masonry', []).controller('MasonryCtrl', ($scope, $element, $timeout) ->
    bricks = {}
    schedule = []
    destroyed = false
    self = this
    timeout = null

    defaultLoaded = ($element) ->
      $element.addClass 'loaded'
      return

    @preserveOrder = false
    @loadImages = true

    @scheduleMasonryOnce = ->
      args = arguments
      found = schedule.filter((item) ->
        item[0] == args[0]
      ).length > 0
      if !found
        @scheduleMasonry.apply null, arguments
      return

    # Make sure it's only executed once within a reasonable time-frame in
    # case multiple elements are removed or added at once.

    @scheduleMasonry = ->
      if timeout
        $timeout.cancel timeout
      schedule.push [].slice.call(arguments)
      timeout = $timeout((->
        if destroyed
          return
        schedule.forEach (args) ->
          $element.masonry.apply $element, args
          return
        schedule = []
        return
      ), 30)
      return

    @appendBrick = (element, id) ->

      _append = ->
        if Object.keys(bricks).length == 0
          $element.masonry 'resize'
        if bricks[id] == undefined
          # Keep track of added elements.
          bricks[id] = true
          defaultLoaded element
          $element.masonry 'appended', element, true
        return

      _layout = ->
        # I wanted to make this dynamic but ran into huuuge memory leaks
        # that I couldn't fix. If you know how to dynamically add a
        # callback so one could say <masonry loaded="callback($element)">
        # please submit a pull request!
        self.scheduleMasonryOnce 'layout'
        return

      if destroyed
        return
      if !self.loadImages
        _append()
        _layout()
      else if self.preserveOrder
        _append()
        element.imagesLoaded _layout
      else
        element.imagesLoaded ->
          _append()
          _layout()
          return
      return

    @removeBrick = (id, element) ->
      if destroyed
        return
      delete bricks[id]
      $element.masonry 'remove', element
      @scheduleMasonryOnce 'layout'
      return

    @destroy = ->
      destroyed = true
      if $element.data('masonry')
        # Gently uninitialize if still present
        $element.masonry 'destroy'
      $scope.$emit 'masonry.destroyed'
      bricks = {}
      return

    @reload = ->
      $element.masonry()
      $scope.$emit 'masonry.reloaded'
      return

    return
  ).directive('masonry', ->
    {
      restrict: 'AE'
      controller: 'MasonryCtrl'
      link: pre: (scope, element, attrs, ctrl) ->
        attrOptions = scope.$eval(attrs.masonry or attrs.masonryOptions)
        options = angular.extend({
          itemSelector: attrs.itemSelector or '.masonry-brick'
          columnWidth: parseInt(attrs.columnWidth, 10) or attrs.columnWidth
        }, attrOptions or {})
        element.masonry options
        scope.masonryContainer = element[0]
        loadImages = scope.$eval(attrs.loadImages)
        ctrl.loadImages = loadImages != false
        preserveOrder = scope.$eval(attrs.preserveOrder)
        ctrl.preserveOrder = preserveOrder != false and attrs.preserveOrder != undefined
        reloadOnShow = scope.$eval(attrs.reloadOnShow)
        if reloadOnShow != false and attrs.reloadOnShow != undefined
          scope.$watch (->
            element.prop 'offsetParent'
          ), (isVisible, wasVisible) ->
            if isVisible and !wasVisible
              ctrl.reload()
            return
        reloadOnResize = scope.$eval(attrs.reloadOnResize)
        if reloadOnResize != false and attrs.reloadOnResize != undefined
          scope.$watch 'masonryContainer.offsetWidth', (newWidth, oldWidth) ->
            if newWidth != oldWidth
              ctrl.reload()
            return
        scope.$emit 'masonry.created', element
        scope.$on '$destroy', ctrl.destroy
        return

    }
  ).directive 'masonryBrick', ->
    {
      restrict: 'AC'
      require: '^masonry'
      scope: true
      link: pre: (scope, element, attrs, ctrl) ->
        id = scope.$id
        index = undefined
        ctrl.appendBrick element, id
        element.on '$destroy', ->
          ctrl.removeBrick id, element
          return
        scope.$on 'masonry.reload', ->
          ctrl.scheduleMasonryOnce 'reloadItems'
          ctrl.scheduleMasonryOnce 'layout'
          return
        scope.$watch '$index', ->
          if index != undefined and index != scope.$index
            ctrl.scheduleMasonryOnce 'reloadItems'
            ctrl.scheduleMasonryOnce 'layout'
          index = scope.$index
          return
        return

    }
  return
