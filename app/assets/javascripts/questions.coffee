# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->  
  questionsList = $(".questions-list")

  edit_question = (e) ->
      e.preventDefault();
      $(this).hide();
      $('.question_body').hide();
      $('.question_title').hide();            
      $('form.edit_question').show();    

  $(document).on 'click', '.edit-question-link', edit_question


  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      questionsList.append data
  })