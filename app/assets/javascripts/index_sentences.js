'use strict';

var indexSentences = function() {
  var typingTimer;
  var $input = $('#search');

  $input.on('input propertychange paste', function () {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(function() {
      // send it via get is not a good idea but all do that for see an feedback
      // on my crap code :)
      if ($input.val().length >= 3) {
        $.get('/search_index?query=' + $input.val(), function() {});
      }
    }, 1200);
  });
};

document.addEventListener('turbolinks:load', function() {
  indexSentences();
});
