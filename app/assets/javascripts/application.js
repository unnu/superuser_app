// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require_tree .


$(function() {
  $('.alert').delay(2000).fadeOut(1700);
  
  $('.ticket').delegate('.cancel-ticket-edit', 'click', function() {
    $.getScript($(this).closest('.ticket').data('url') + '.js');
    
  });
  
  $('.ticket').delegate('.submit-ticket', 'click', function() {
    $(this).closest('.ticket').find('form').submit();
  });
  
  $('.date').datepicker();
  
  $('.dropdown-toggle').dropdown();
})