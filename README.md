# Angular Masonry Directive

[Homepage](http://passy.github.io/angular-masonry)

An AngularJS directive to work with David Desandro's [Masonry](http://masonry.desandro.com/).

## Usage

1. `bower install --save angular-masonry`
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


## Credits

The directive is based on
[a StackOverflow question](http://stackoverflow.com/questions/16504151/masonry-with-angularjs)
answered by James Sharp.

## License

MIT
