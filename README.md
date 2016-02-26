# AngularJS Masonry Directive [![Build Status](https://travis-ci.org/passy/angular-masonry.svg?branch=master)](https://travis-ci.org/passy/angular-masonry)[![Dependency Status](https://gemnasium.com/passy/angular-masonry.svg)](https://gemnasium.com/passy/angular-masonry) [![Code Climate](https://codeclimate.com/github/passy/angular-masonry/badges/gpa.svg)](https://codeclimate.com/github/passy/angular-masonry)

[Homepage](https://passy.github.io/angular-masonry)

An [AngularJS 1](https://angularjs.org/) directive to work with David Desandro's [Masonry](http://masonry.desandro.com/).

## Usage

1. Install via either [bower](http://bower.io/) or [npm](https://www.npmjs.com/):
    1. `bower install --save angular-masonry`
    2. `npm install --save angular-masonry`
2. Add `wu.masonry` to your application's module dependencies.
3. Include dependencies in your HTML.
      ```html
      <script src="bower_components/jquery/dist/jquery.js"></script>
      <script src="bower_components/jquery-bridget/jquery-bridget.js"></script>
      <script src="bower_components/ev-emitter/ev-emitter.js"></script>
      <script src="bower_components/desandro-matches-selector/matches-selector.js"></script>
      <script src="bower_components/fizzy-ui-utils/utils.js"></script>
      <script src="bower_components/get-size/get-size.js"></script>
      <script src="bower_components/outlayer/item.js"></script>
      <script src="bower_components/outlayer/outlayer.js"></script>
      <script src="bower_components/masonry/masonry.js"></script>
      <script src="bower_components/imagesloaded/imagesloaded.js"></script>
      <script src="bower_components/angular/angular.js"></script>
      <script src="bower_components/angular-masonry/angular-masonry.js"></script>
      ```
    
4. Use the `masonry` directive.

## Example

See the [homepage](http://passy.github.io/angular-masonry) for a live example.

```html
<div masonry>
    <div class="masonry-brick" ng-repeat="brick in bricks">
        <img ng-src="{{ brick.src }}" alt="A masonry brick">
    </div>
</div>
```

You have to include the `masonry` attribute on the element holding the bricks.
The bricks are registered at the directive through the `masonry-brick` CSS
classname.

The directive uses [`imagesloaded`](https://github.com/desandro/imagesloaded) to
determine when all images within the `masonry-brick` have been loaded and adds
the `loaded` CSS class to the element, so you can add custom styles and
prevent ghosting effects.

## Attributes

### `item-selector`

(Default: `.masonry-brick`)

You can specify a different [item
selector](http://masonry.desandro.com/options.html#itemselector) through the
`item-selector` attribute. You still need to use `masonry-brick` either as class
name or element attribute on sub-elements in order to register it to the
directive.

*Example:*

```html
<masonry item-selector=".mybrick">
    <div masonry-brick class="mybrick">Unicorns</div>
    <div masonry-brick class="mybrick">Sparkles</div>
</masonry>
```

### `column-width`

The `column-width` attribute allows you to override the [the width of a column
of a horizontal grid](http://masonry.desandro.com/options.html#columnwidth). If
not set, Masonry will use the outer width of the first element.

*Example:*

```html
<masonry column-width="200">
    <div class="masonry-brick">This will be 200px wide max.</div>
</masonry>
```

### `preserve-order`

The `preserve-order` attributes disables the `imagesLoaded` logic and will
instead display bricks by the order in the DOM instead of by the time they are
loaded. Be aware that this can lead to visual glitches if the size of the
elements isn't set at the time they are inserted.

*Example:*

```html
<masonry preserve-order>
    <div class="masonry-brick"><img src="..." alt="Will always be shown 1st"></div>
    <div class="masonry-brick"><img src="..." alt="Will always be shown 2nd"></div>
</masonry>
```

### `load-images`

This attribute defaults to `true` and allows to disable the use of `imagesLoaded`
altogether, so you don't have to include the dependency if your masonry layout
doesn't actually make use of images.

*Example:*

```html
<masonry load-images="false">
    <div class="masonry-brick"><p>Only text.</p></div>
    <div class="masonry-brick"><p>And nothing but text.</p></div>
</masonry>
```

### `reload-on-show`

The `reload-on-show` attribute triggers a reload when the masonry element (or an
ancestor element) is shown after being hidden, useful when using `ng-show` or 
`ng-hide`. Without this if the viewport is resized while the masonry element is 
hidden it may not render properly when shown again.

*Example:*

```html
<masonry reload-on-show ng-show="showList">
    <div class="masonry-brick">...</div>
    <div class="masonry-brick">...</div>
</masonry>
```

When `showList` changes from falsey to truthy `ctrl.reload` will be called.


### `reload-on-resize`

The `reload-on-resize` attribute triggers a reload when the masonry element changes
its width, useful when only the parent element is resized (and not the window) and 
you want the elements to be rearranged. Without this if the parent is resized then 
some blank space may be left on the sides.

*Example:*

```html
<masonry reload-on-resize>
    <div class="masonry-brick">...</div>
    <div class="masonry-brick">...</div>
</masonry>
```


### `masonry-options`

You can provide [additional options](http://masonry.desandro.com/options.html)
as expression either as `masonry` or `masonry-options` attribute.

*Example:*

```html
<masonry masonry-options="{ transitionDuration: '0.4s' }">
</masonry>
```

Equivalent to:

```html
<div masonry="{ transitionDuration: '0.4s' }">
</div>
```

### `prepend`

Bricks are appended by default. This behavior can be specified for each brick by
providing the `prepend` attribute.

*Example:*

```html
<div masonry>
    <div class="masonry-brick" prepend="isPrepended()">...</div>
</div>
```

## Credits

The directive is based on
[a StackOverflow question](http://stackoverflow.com/questions/16504151/masonry-with-angularjs)
answered by James Sharp.


## Contributing

Please refer to [CONTRIBUTING.md](CONTRIBUTING.md) before opening issues or pull
requests.

## License

MIT


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/passy/angular-masonry/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

