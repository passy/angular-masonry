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

  describe 'directive initialization', =>
    beforeEach =>
      @Masonry = window.Masonry;
      window.Masonry = sinon.spy();

    afterEach =>
      window.Masonry = @Masonry;

    it 'should initialize', inject(($compile) =>
      element = angular.element '<masonry></masonry>'
      element = $compile(element)(@scope)
    )

    it 'should call masonry on init', inject(($compile) =>
      element = angular.element '<div masonry></div>'
      element = $compile(element)(@scope)

      expect(window.Masonry).toHaveBeenCalled()
    )

    it 'should pass on the column-width attribute', inject(($compile) =>
      element = angular.element '<masonry column-width="200"></masonry>'
      element = $compile(element)(@scope)

      expect(window.Masonry).toHaveBeenCalledOnce()
      call = window.Masonry.firstCall
      expect(call.args[1].columnWidth).toBe 200
    )

    it 'should pass on the item-selector attribute', inject(($compile) =>
      element = angular.element '<masonry item-selector=".mybrick"></masonry>'
      element = $compile(element)(@scope)

      expect(window.Masonry).toHaveBeenCalled()
      call = window.Masonry.firstCall
      expect(call.args[1].itemSelector).toBe '.mybrick'
    )

    it 'should pass on any options provided via `masonry-options`', inject(($compile) =>
      element = angular.element '<masonry masonry-options="{ isOriginLeft: true }"></masonry>'
      element = $compile(element)(@scope)

      expect(window.Masonry).toHaveBeenCalled()
      call = window.Masonry.firstCall
      expect(call.args[1].isOriginLeft).toBeTruthy()
    )

    it 'should pass on any options provided via `masonry`', inject(($compile) =>
      element = angular.element '<div masonry="{ isOriginLeft: true }"></div>'
      element = $compile(element)(@scope)

      expect(window.Masonry).toHaveBeenCalled()
      call = window.Masonry.firstCall
      expect(call.args[1].isOriginLeft).toBeTruthy()
    )

  describe 'directive watchers', =>
    it 'should setup a $watch when the reload-on-show is present', inject(($compile) =>
      sinon.spy(@scope, '$watch')
      element = angular.element '<masonry reload-on-show></masonry>'
      element = $compile(element)(@scope)

      expect(@scope.$watch).toHaveBeenCalled()
    )

    it 'should not setup a $watch when the reload-on-show is missing', inject(($compile) =>
      sinon.spy(@scope, '$watch')
      element = angular.element '<masonry></masonry>'
      element = $compile(element)(@scope)

      expect(@scope.$watch).not.toHaveBeenCalled()
    )

    it 'should setup a $watch when the reload-on-resize is present', inject(($compile) =>
      sinon.spy(@scope, '$watch')
      element = angular.element '<masonry reload-on-resize></masonry>'
      element = $compile(element)(@scope)

      expect(@scope.$watch).toHaveBeenCalledWith('masonryContainer.offsetWidth', sinon.match.func );
    )

    it 'should not setup a $watch when the reload-on-resize is missing', inject(($compile) =>
      sinon.spy(@scope, '$watch')
      element = angular.element '<masonry></masonry>'
      element = $compile(element)(@scope)

      expect(@scope.$watch).not.toHaveBeenCalledWith('masonryContainer.offsetWidth', sinon.match.func );
    )

  describe 'MasonryCtrl', =>
    beforeEach inject(($compile) =>
      $compile('<masonry></masonry>')(@scope)
      @ctrl = @scope.msnry
      @ctrl.destroy()
    )

    it 'should not remove after destruction', =>
      @ctrl.remove = sinon.spy();
      @ctrl.removeBrick()

      expect(@ctrl.remove).not.toHaveBeenCalled()

    it 'should not add after destruction', =>
      @ctrl.add = sinon.spy();
      @ctrl.addBrick()

      expect(@ctrl.add).not.toHaveBeenCalled()


  describe 'masonry-brick', =>
    beforeEach =>
      controllerProvider.register('MasonryCtrl', ->
        @addBrick = sinon.spy()
        @removeBrick = sinon.spy()
        @scheduleMasonry = sinon.spy()
        @scheduleMasonryOnce = sinon.spy()
        this
      )

    it 'should register an element in the parent controller', inject(($compile) =>
      element = angular.element '''
        <masonry>
          <div class="masonry-brick"></div>
        </masonry>
      '''
      element = $compile(element)(@scope)

      expect(@scope.msnry.addBrick).toHaveBeenCalledOnce()
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

      expect(@scope.msnry.addBrick).toHaveBeenCalledThrice()
      expect(@scope.msnry.removeBrick).toHaveBeenCalledOnce()
    )

  describe 'MasonryCtrl.addBrick', =>
    beforeEach ->
      controllerProvider.register('MasonryCtrl', ->
        @addBrick = sinon.spy()
        this
      )

    it 'should append three elements to the controller', inject(($compile) =>
      element = angular.element '''
        <masonry>
          <div class="masonry-brick"></div>
          <div class="masonry-brick"></div>
          <div class="masonry-brick"></div>
        </masonry>
      '''
      element = $compile(element)(@scope)

      expect(@scope.msnry.addBrick.callCount).toBe 3
    )

    it 'should prepend elements when specified by attribute', inject(($compile) =>
      element = angular.element '''
        <masonry>
          <div class="masonry-brick" prepend="{{true}}"></div>
        </masonry>
      '''
      element = $compile(element)(@scope)

      expect(@scope.msnry.addBrick).toHaveBeenCalledWith 'prepended'
    )

    it 'should append before imagesLoaded when preserve-order is set', inject(($compile) =>
      element = angular.element '''
        <masonry load-images="true" preserve-order>
          <div class="masonry-brick"></div>
        </masonry>
      '''
      element = $compile(element)(@scope)

      expect(@scope.msnry.addBrick).toHaveBeenCalledWith 'appended'
    )

  describe 'MasonryCtrl.scheduleMasonryOnce', =>
    beforeEach =>
      @imagesLoadedCb = undefined
      $.fn.imagesLoaded = (cb) => @imagesLoadedCb = cb

    it 'should call layout after imagesLoaded when preserve-order is set', inject(($compile, $timeout) =>
      @layout = window.Masonry.prototype.layout
      @spy = sinon.spy(window.Masonry.prototype, 'layout')

      element = angular.element '''
        <masonry load-images="true" preserve-order>
          <div class="masonry-brick"></div>
        </masonry>
      '''
      $compile(element)(@scope)

      @scope.$digest()
      expect(@spy).toHaveBeenCalledOnce()

      @imagesLoadedCb()
      $timeout.flush()
      expect(@spy).toHaveBeenCalledTwice()
      window.Masonry.prototype.layout = @layout
    )

    it 'should append before imagesLoaded when load-images is set to "false"', inject(($compile) =>
      @appended = window.Masonry.prototype.appended
      @spy = sinon.spy(window.Masonry.prototype, 'appended')

      element = angular.element '''
        <masonry>
          <div class="masonry-brick"></div>
        </masonry>
      '''
      $compile(element)(@scope)

      expect(@spy).toHaveBeenCalledOnce()
      window.Masonry.prototype.appended = @appended
    )

    it 'should call layout before imagesLoaded when load-images is set to "false"', inject(($compile, $timeout) =>
      @layout = window.Masonry.prototype.layout
      @spy = sinon.spy(window.Masonry.prototype, 'layout');

      $compile('''
        <masonry load-images="false">
          <div class="masonry-brick"></div>
        </masonry>
      ''')(@scope)

      @scope.$digest()
      $timeout.flush()

      expect(@spy).toHaveBeenCalled()
      window.Masonry.prototype.layout = @layout
    )
