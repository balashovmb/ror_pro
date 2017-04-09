App.cable.subscriptions.create "AnswersChannel",
  connected: ->
    @followCurrenQuestion()
    console.log 'Connected AnswersChannel'
  ,
  received: (data) ->
    console.log 'Data received'    
    $('.answers').append data

  followCurrenQuestion: ->
    questionId = $('.question').data('id')
    console.log questionId 
    if questionId 
      @perform 'subscribe_question_stream', id: questionId
    else
      @perform 'unsubscribe_question_stream'
