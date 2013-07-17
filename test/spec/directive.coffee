describe 'angular-masonry', ->

  controllerProvider = null

  beforeEach module('wu.masonry')
  beforeEach module((_$controllerProvider_) ->
    controllerProvider = _$controllerProvider_
    null
  )

  beforeEach inject(($rootScope) =>
    @scope = $rootScope.$new()
    $.fn.masonry.reset()
  )

  it 'should initialize', inject(($compile) =>
    element = angular.element '<masonry></masonry>'
    element = $compile(element)(@scope)
  )

  it 'should call masonry on init', inject(($compile) =>
    element = angular.element '<div masonry></div>'
    element = $compile(element)(@scope)

    expect($.fn.masonry).toHaveBeenCalled()
  )

  it 'should pass on the column-width attribute', inject(($compile) =>
    element = angular.element '<masonry column-width="200"></masonry>'
    element = $compile(element)(@scope)

    expect($.fn.masonry).toHaveBeenCalledOnce()
    call = $.fn.masonry.firstCall
    expect(call.args[0].columnWidth).toBe '200'
  )

  it 'should pass on the item-selector attribute', inject(($compile) =>
    element = angular.element '<masonry item-selector=".mybrick"></masonry>'
    element = $compile(element)(@scope)

    expect($.fn.masonry).toHaveBeenCalled()
    call = $.fn.masonry.firstCall
    expect(call.args[0].itemSelector).toBe '.mybrick'
  )

  it 'should pass on any options probided', inject(($compile) =>
    element = angular.element '<masonry options="{ isOriginLeft: true }"></masonry>'
    element = $compile(element)(@scope)

    expect($.fn.masonry).toHaveBeenCalled()
    call = $.fn.masonry.firstCall
    expect(call.args[0].isOriginLeft).toBeTruthy()
  )

  describe 'MasonryCtrl', =>
    beforeEach inject(($controller, $compile) =>
      @element = angular.element '<div></div>'
      @ctrl = $controller 'MasonryCtrl', {
        $scope: @scope
        $element: @element
      }
    )

    it 'should not remove after destruction', =>
      @ctrl.destroy()
      @ctrl.removeBrick()

      expect($.fn.masonry).not.toHaveBeenCalled()

    it 'should not add after destruction', =>
      @ctrl.destroy()
      @ctrl.appendBrick()

      expect($.fn.masonry).not.toHaveBeenCalled()



  describe 'masonry-brick', =>
    beforeEach =>
      self = this
      @appendBrick = sinon.spy()
      @removeBrick = sinon.spy()

      controllerProvider.register('MasonryCtrl', ->
        @appendBrick = self.appendBrick
        @removeBrick = self.removeBrick
      )

    it 'should register an element in the parent controller', inject(($compile) =>
      element = angular.element '''
        <masonry>
          <div class="masonry-brick"></div>
        </masonry>
      '''
      element = $compile(element)(@scope)

      expect(@appendBrick).toHaveBeenCalledOnce()
    )

    it 'should remove an element in the parent controller if destroyed', inject(($compile) =>
      @scope.bricks = [1, 2, 3]
      element = angular.element '''
        <masonry>
          <div class="masonry-brick" ng-repeat="brick in bricks"></div>
        </masonry>
      '''
      element = $compile(element)(@scope)
      @scope.$digest() # Needed for initial ng-repeat

      @scope.$apply(=>
        @scope.bricks.splice(0, 1)
      )

      expect(@appendBrick).toHaveBeenCalledThrice()
      expect(@removeBrick).toHaveBeenCalledOnce()
    )
