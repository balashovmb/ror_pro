App.cable.subscriptions.create "AnswersChannel",
  connected: ->
    @followCurrenQuestion()
    console.log 'Connected AnswersChannel'
  ,
  received: (data) ->
    console.log data.answer.user_id
    if gon.current_user_id != data.answer.user_id
      $('.answers').append(JST['templates/answer'](data))

  followCurrenQuestion: ->
    questionId = $('.question').data('id')
    console.log questionId 
    if questionId 
      @perform 'subscribe_question_stream', id: questionId
    else
      @perform 'unsubscribe_question_stream'
