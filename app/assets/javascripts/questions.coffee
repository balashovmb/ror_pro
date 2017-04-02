# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

edit_question = (e) ->
    e.preventDefault();
    $(this).hide();
    $('.question_body').hide();
    $('.question_title').hide();            
    $('form.edit_question').show();    

$(document).on 'click', '.edit-question-link', edit_question

vote_question = (e) ->
  $('.vote-question-link').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.question-rating').html('<p>Rating: ' + response.rating + '</p>')
    $('.question-errors').html('')
  .bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $('.question-errors').html('<p>' + response.data + '</p>')   

$(document).on 'click', '.vote-question-link', vote_question

