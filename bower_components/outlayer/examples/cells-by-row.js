/**
 * CellsByRow example
 */

( function( window ) {

'use strict';

function cellsByRowDefinition( Outlayer ) {

var CellsByRow = Outlayer.create( 'cellsByRow', {
  columnWidth: 100,
  rowHeight: 100
});

CellsByRow.prototype._resetLayout = function() {
  this.getSize();

  this._getMeasurement( 'columnWidth', 'outerWidth' );
  this._getMeasurement( 'rowHeight', 'outerHeight' );

  this.cols = Math.floor( this.size.innerWidth / this.columnWidth );
  this.cols = Math.max( this.cols, 1 );

  this.itemIndex = 0;
};

CellsByRow.prototype._getItemLayoutPosition = function( item ) {
  item.getSize();
  var column = this.itemIndex % this.cols;
  var row = Math.floor( this.itemIndex / this.cols );
  var x = column * this.columnWidth;
  var y = row * this.rowHeight;
  this.itemIndex++;
  return {
    x: x,
    y: y
  };
};

CellsByRow.prototype._getContainerSize = function() {
  return {
    height: Math.ceil( this.itemIndex / this.cols ) * this.rowHeight
  };
};

return CellsByRow;

}

// -------------------------- transport -------------------------- //


if ( typeof define === 'function' && define.amd ) {
  // AMD
  define( [
      '../outlayer'
    ],
    cellsByRowDefinition );
} else {
  // browser global
  window.CellsByRow = cellsByRowDefinition(
    window.Outlayer
  );
}

})( window );
