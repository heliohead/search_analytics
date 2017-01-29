'use strict';

var Autocomplete = (function() {
  return {
    complete: function() {
      $('#search').autocomplete({
        serviceUrl: '/searches',
        onSelect: function (suggestion) {
          window.alert('You selected: ' + suggestion.value + ', ' + suggestion.data);
        }
      });
    },
    init: function() {
      this.complete();
    }
  };
}());

document.addEventListener('turbolinks:load', function() {
  Autocomplete.init();
});
