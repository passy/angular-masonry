describe 'angular-masonry', ->

  beforeEach module('wu.masonry')
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

    expect($.fn.masonry).toHaveBeenCalled()
  )

  # TODO: Refactor directive to just proxy everything to an object I can
  # actually test - or - figure out how to override a controller injection.
