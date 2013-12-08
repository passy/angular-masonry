# AngularJS Masonry Directive [![Build Status](https://travis-ci.org/passy/angular-masonry.png)](https://travis-ci.org/passy/angular-masonry) [![Dependency Status](https://gemnasium.com/passy/angular-masonry.png)](https://gemnasium.com/passy/angular-masonry) [![Code Climate](https://codeclimate.com/github/passy/angular-masonry.png)](https://codeclimate.com/github/passy/angular-masonry)

[Homepage](http://passy.github.io/angular-masonry)

An [AngularJS](http://angularjs.org/) directive to work with David Desandro's [Masonry](http://masonry.desandro.com/).

## Usage

1. `bower install --save angular-masonry`
2. Add `wu.masonry` to your application's module dependencies.
2. Include dependencies in your HTML.
3. Use the `masonry` directive.

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
the `loaded` CSS class to to the element, so you can add custom styles and
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

### `masonry-options`

You can provide [additional options](http://masonry.desandro.com/options.html)
as expression either as `masonry` or `masonry-options` attribute.

*Example:*

```html
<masonry masonry-options="{ transitionTransition: '0.4s' }">
</masonry>
```

Equivalent to:

```html
<div masonry="{ transitionTransition: '0.4s' }">
</div>
```

## Credits

The directive is based on
[a StackOverflow question](http://stackoverflow.com/questions/16504151/masonry-with-angularjs)
answered by James Sharp.


## Contributing

Pull requests welcome. Only change files in `src` and don't bump any versions.
Please respect the code style in place.

## License

MIT


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/passy/angular-masonry/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

