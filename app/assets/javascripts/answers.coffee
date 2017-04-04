# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

edit_answer = (e) ->
  e.preventDefault();
  $(this).hide();
  answer_id = $(this).data('answerId');
  $('#edited-answer-' + answer_id).hide();      
  $('form#edit-answer-' + answer_id).show();    

$(document).on 'click', '.edit-answer-link', edit_answer

