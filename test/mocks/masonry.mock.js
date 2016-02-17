(function () {
  'use strict';
  $.fn.masonry = sinon.stub();
  $.fn.masonry.withArgs('getItemElements').returns([]);
}());
