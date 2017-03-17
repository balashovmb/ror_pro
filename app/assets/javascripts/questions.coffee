# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.question_body').hide();
    $('.question_title').hide();            
    $('form.edit_question').show();    

$(document).ready(ready) 
$(document).on('page:load', ready) 
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)