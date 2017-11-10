//= require rails-ujs
//= require jquery
//= require jquery_ujs
//= require jquery.transit.js
//= require jquery.validate
//= require bootstrap-sprockets
//= require bootstrap-multiselect
//= require conversations
//= require articles.js
//= require select2-full
//= require ckeditor/init
//= require_tree .


$(document).ready(function() {
  $('pre code').each(function(i, block) {
    hljs.highlightBlock(block);
  });
});

