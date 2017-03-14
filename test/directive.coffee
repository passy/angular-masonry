describe 'angular-masonry', ->

  controllerProvider = null

  beforeEach module('wu.masonry')
  beforeEach module((_$controllerProvider_) ->
    controllerProvider = _$controllerProvider_
    null
  )

  beforeEach inject(($rootScope, $compile) =>
    @compile = $compile
    @scope = $rootScope.$new()
  )

  describe 'directive initialization', =>
    beforeEach =>
      @Masonry = window.Masonry
      window.Masonry = sinon.spy()

    afterEach =>
      window.Masonry = @Masonry

    it 'should initialize', =>
      @compile('<div masonry></div>')(@scope)

    it 'should call masonry on init', =>
      @compile('<div masonry></div>')(@scope)
      expect(window.Masonry).toHaveBeenCalled()

    it 'should pass on the column-width attribute', =>
      @compile('<div masonry column-width="200"></div>')(@scope)
      expect(window.Masonry).toHaveBeenCalledOnce()

      call = window.Masonry.firstCall
      expect(call.args[1].columnWidth).toBe 200

    it 'should pass on the item-selector attribute', =>
      @compile('<div masonry item-selector=".mybrick"></div>')(@scope)
      expect(window.Masonry).toHaveBeenCalled()

      call = window.Masonry.firstCall
      expect(call.args[1].itemSelector).toBe '.mybrick'

    it 'should pass on any options provided via `masonry-options`', =>
      @compile('<div masonry masonry-options="{ isOriginLeft: true }"></div>')(@scope)
      expect(window.Masonry).toHaveBeenCalled()

      call = window.Masonry.firstCall
      expect(call.args[1].isOriginLeft).toBeTruthy()

    it 'should pass on any options provided via `masonry`', =>
      @compile('<div masonry="{ isOriginLeft: true }"></div>')(@scope)
      expect(window.Masonry).toHaveBeenCalled()

      call = window.Masonry.firstCall
      expect(call.args[1].isOriginLeft).toBeTruthy()

  describe 'directive watchers', =>
    beforeEach =>
      sinon.spy(@scope, '$watch')

    it 'should setup a $watch when the reload-on-show is present', =>
      @compile('<div masonry reload-on-show></div>')(@scope)
      expect(@scope.$watch).toHaveBeenCalled()

    it 'should not setup a $watch when the reload-on-show is missing', =>
      @compile('<div masonry></div>')(@scope)
      expect(@scope.$watch).not.toHaveBeenCalled()

    it 'should setup a $watch when the reload-on-resize is present', =>
      @compile('<div masonry reload-on-resize></div>')(@scope)
      expect(@scope.$watch).toHaveBeenCalledWith('masonryContainer.offsetWidth', sinon.match.func);

    it 'should not setup a $watch when the reload-on-resize is missing', =>
      @compile('<div masonry></div>')(@scope)
      expect(@scope.$watch).not.toHaveBeenCalledWith('masonryContainer.offsetWidth', sinon.match.func);

  describe 'MasonryCtrl', =>
    beforeEach =>
      @compile('<div masonry></div>')(@scope)
      @ctrl = @scope.msnry
      @ctrl.destroy()

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

    it 'should register an element in the parent controller', =>
      @compile('''
        <div masonry>
          <div class="masonry-brick"></div>
        </div>
      ''')(@scope)

      expect(@scope.msnry.addBrick).toHaveBeenCalledOnce()

    it 'should remove an element in the parent controller if destroyed', =>
      @scope.bricks = [1, 2, 3]

      @compile('''
        <div masonry>
          <div class="masonry-brick" ng-repeat="brick in bricks"></div>
        </div>
      ''')(@scope)

      @scope.$digest() # Needed for initial ng-repeat

      @scope.$apply(=>
        @scope.bricks.splice(0, 1)
      )

      expect(@scope.msnry.addBrick).toHaveBeenCalledThrice()
      expect(@scope.msnry.removeBrick).toHaveBeenCalledOnce()

  describe 'MasonryCtrl.addBrick', =>
    beforeEach ->
      controllerProvider.register('MasonryCtrl', ->
        @addBrick = sinon.spy()
        this
      )

    it 'should append three elements to the controller', =>
      @compile('''
        <div masonry>
          <div class="masonry-brick"></div>
          <div class="masonry-brick"></div>
          <div class="masonry-brick"></div>
        </div>
      ''')(@scope)

      expect(@scope.msnry.addBrick.callCount).toBe 3

    it 'should prepend elements when specified by attribute', =>
      @compile('''
        <div masonry>
          <div class="masonry-brick" prepend="{{true}}"></div>
        </div>
      ''')(@scope)

      expect(@scope.msnry.addBrick).toHaveBeenCalledWith 'prepended'

    it 'should append before imagesLoaded when preserve-order is set', =>
      @compile('''
        <div masonry load-images="true" preserve-order>
          <div class="masonry-brick"></div>
        </div>
      ''')(@scope)

      expect(@scope.msnry.addBrick).toHaveBeenCalledWith 'appended'

  describe 'MasonryCtrl.scheduleMasonryOnce', =>
    beforeEach =>
      @imagesLoadedCb = undefined
      window.imagesLoaded = (el, cb) => @imagesLoadedCb = cb

    it 'should call layout after imagesLoaded when preserve-order is set', inject(($timeout) =>
      @layout = window.Masonry.prototype.layout
      @spy = sinon.spy(window.Masonry.prototype, 'layout')

      @compile('''
        <div masonry load-images="true" preserve-order>
          <div class="masonry-brick"></div>
        </div>
      ''')(@scope)

      @scope.$digest()
      expect(@spy).toHaveBeenCalledOnce()

      @imagesLoadedCb()
      $timeout.flush()
      expect(@spy).toHaveBeenCalledTwice()
      window.Masonry.prototype.layout = @layout
    )

    it 'should append before imagesLoaded when load-images is set to "false"', =>
      @appended = window.Masonry.prototype.appended
      @spy = sinon.spy(window.Masonry.prototype, 'appended')

      @compile('''
        <div masonry>
          <div class="masonry-brick"></div>
        </div>
      ''')(@scope)

      expect(@spy).toHaveBeenCalledOnce()
      window.Masonry.prototype.appended = @appended

    it 'should call layout before imagesLoaded when load-images is set to "false"', inject(($timeout) =>
      @layout = window.Masonry.prototype.layout
      @spy = sinon.spy(window.Masonry.prototype, 'layout');

      @compile('''
        <div masonry load-images="false">
          <div class="masonry-brick"></div>
        </div>
      ''')(@scope)

      @scope.$digest()
      $timeout.flush()

      expect(@spy).toHaveBeenCalled()
      window.Masonry.prototype.layout = @layout
    )
