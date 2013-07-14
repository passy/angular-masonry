describe 'angular-masonry', ->

  controllerProvider = null

  beforeEach module('wu.masonry')
  beforeEach module((_$controllerProvider_) ->
    controllerProvider = _$controllerProvider_
    null
  )

  beforeEach inject(($rootScope) =>
    @scope = $rootScope.$new()
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
