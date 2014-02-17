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
    element = angular.element '<masonry></masonry>'
    element = $compile(element)(@scope)
    masonry = element.scope().mason;

    expect(masonry).toBeDefined()
  )

  it 'should pass on the column-width attribute', inject(($compile) =>
    element = angular.element '<masonry column-width="200"></masonry>'
    element = $compile(element)(@scope)
    masonry = element.scope().mason;

    expect(masonry).toBeDefined()
    expect(masonry.options.columnWidth).toBe 200
  )

  it 'should pass on the item-selector attribute', inject(($compile) =>
    element = angular.element '<masonry item-selector=".mybrick"></masonry>'
    element = $compile(element)(@scope)
    masonry = element.scope().mason;

    expect(masonry).toBeDefined()
    expect(masonry.options.itemSelector).toBe '.mybrick'
  )

  it 'should pass on any options provided via `masonry-options`', inject(($compile) =>
    element = angular.element '<masonry masonry-options="{ isOriginLeft: true }"></masonry>'
    element = $compile(element)(@scope)
    masonry = element.scope().mason;

    expect(masonry).toBeDefined()
    expect(masonry.options.isOriginLeft).toBeTruthy()
  )

  it 'should pass on any options provided via `masonry`', inject(($compile) =>
    element = angular.element '<div masonry="{ isOriginLeft: true }"></div>'
    element = $compile(element)(@scope)
    masonry = element.scope().mason;

    expect(masonry).toBeDefined()
    expect(masonry.options.isOriginLeft).toBeTruthy()
  )

  it '$scope.$on(\'masonry.created\') should have been called', inject(($compile) =>
    spyOn(@scope, '$emit')

    element = angular.element '<div masonry></div>'
    element = $compile(element)(@scope)

    expect(@scope.$emit).toHaveBeenCalledWith('masonry.created', jasmine.any(Object))
  )

  describe 'MasonryCtrl', =>
    beforeEach inject(($compile) =>
      element = angular.element '<masonry></masonry>'
      element = $compile(element)(@scope)
      
      @ctrl = element.controller('masonry')
      @mason = element.scope().mason

      spyOn(@mason, 'remove')
      spyOn(@mason, 'appended')
    )

    it 'should not remove after destruction', =>
      @ctrl.destroy()
      @ctrl.removeBrick()
      expect(@mason.remove).not.toHaveBeenCalled()

    it 'should not add after destruction', =>
      @ctrl.destroy()
      @ctrl.appendBrick()
      expect(@mason.appended).not.toHaveBeenCalled()

  describe 'masonry-brick', =>
    beforeEach =>
      self = this
      @appendBrick = sinon.spy()
      @removeBrick = sinon.spy()
      @scheduleMasonry = sinon.spy()
      @scheduleMasonryOnce = sinon.spy()

      controllerProvider.register('MasonryCtrl', =>
        @appendBrick = self.appendBrick
        @removeBrick = self.removeBrick
        @scheduleMasonry = self.scheduleMasonry
        @scheduleMasonryOnce = self.scheduleMasonryOnce
        this
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

  describe 'masonry-brick internals', =>
    # beforeEach ->
    #   $.fn.imagesLoaded = (cb) -> cb()

    beforeEach =>
      imagesLoaded = (cb) -> cb()

    # afterEach ->
    #   delete $.fn.imagesLoaded

    it 'should append three elements to the controller', inject(($compile) =>
      element = angular.element '''
        <masonry>
          <div class="masonry-brick"></div>
          <div class="masonry-brick"></div>
          <div class="masonry-brick"></div>
        </masonry>
      '''
      element = $compile(element)(@scope)
      @scope.$digest()
      # 2 is resize and one layout, 3 for the elements
      # expect($.fn.masonry.callCount).toBe(2 + 3)
      expect(@appendBrick).toHaveBeenCalledThrice()
    )

    # it 'should append before imagesLoaded when preserve-order is set', inject(($compile) =>
    #   spyOn(Masonry.prototype, 'appended')

    #   element = angular.element '''
    #     <masonry preserve-order>
    #       <div class="masonry-brick"></div>
    #     </masonry>
    #   '''

    #   # imagesLoadedCb = undefined
    #   # window.imagesLoaded = (cb) => imagesLoadedCb = cb

    #   element = $compile(element)(@scope)
    #   mason = element.scope().mason
    #   @scope.$digest()
    #   # expect($.fn.masonry.calledWith('appended', sinon.match.any, sinon.match.any)).toBe(true)
    #   expect(mason.appended).toHaveBeenCalled()
    # )

    # it 'should call layout after imagesLoaded when preserve-order is set', inject(($compile, $timeout) =>
    #   spyOn(Masonry.prototype, 'layout')

    #   element = angular.element '''
    #     <masonry preserve-order>
    #       <div class="masonry-brick"></div>
    #     </masonry>
    #   '''

    #   # imagesLoadedCb = undefined
    #   # imagesLoaded = (cb) -> imagesLoadedCb = cb
    #   element = $compile(element)(@scope)
    #   mason = element.scope().mason
    #   @scope.$digest()
    #   # expect($.fn.masonry.calledWith('layout', sinon.match.any, sinon.match.any)).toBe(false)
    #   # expect(mason.layout).not.toHaveBeenCalled()
    #   # imagesLoadedCb()
    #   # $timeout.flush()
    #   # expect($.fn.masonry.calledWith('layout', sinon.match.any, sinon.match.any)).toBe(true)
    # )
