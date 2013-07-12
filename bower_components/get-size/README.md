# getSize

Get the size of elements.

``` js
var size = getSize( elem );
// elem can be an element
var size = getSize( document.querySelector('#selector') )
// elem can be a string, used as a query selector
var size = getSize('#selector')
```

Returns an object with:  `width`, `height`, `innerWidth/Height`, `outerWidth/Height`, `paddingLeft/Top/Right/Bottom`, `marginLeft/Top/Right/Bottom`, `borderLeft/Top/Right/BottomWidth` and `isBorderBox`.

Tested in IE8, IE9 and good browsers.

## Bower

getSize is a [Bower](https://github.com/twitter/bower) package

``` bash
bower install desandro/get-size
```

## Fractional values in IE8

For percentage or `em`-based sizes, IE8 does not support fractional values. getSize will round to the nearest value.
