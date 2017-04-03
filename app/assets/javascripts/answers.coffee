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

vote_answer_success = (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('#answer-'+ answer.id + ' .answer-rating').html('<p>Rating: ' + answer.rating + '</p>')
    $('.answer-vote-errors').html('')

vote_answer_error = (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $('#answer-'+ response.id + ' .answer-vote-errors').html(response.data)  


$(document).on 'ajax:success', '.vote-answer-link', vote_answer_success
$(document).on 'ajax:error', '.vote-answer-link', vote_answer_error
