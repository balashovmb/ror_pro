App.answers_channel = App.cable.subscriptions.create "AnswersChannel",
  connected: ->
    @followCurrenQuestion()
    @installPageCallback()
    console.log 'Connected AnswersChannel'

  received: (data) ->
    console.log data.type
    if data.type == "answer"
      if data.action == "delete"
        targetDiv = $('#answer-' + data.answer_id)
        targetDiv.remove();
      else
        $('.answers').append(JST['templates/answer'](data))
    if data.type == "comment"
      targetDiv = '#' + data.comment.commentable_type + '-' + data.comment.commentable_id + '-comments'
      $('form#new_comment').remove()
      $('#errors-field').html('')
      $(targetDiv).append(JST["templates/comment"]({comment: data.comment}))
    return

  followCurrenQuestion: ->
    questionId = $('.question').data('id')
    console.log questionId
    if questionId
      @perform 'subscribe_question_stream', id: questionId
    else
      @perform 'unsubscribe_question_stream'
  installPageCallback: ->
    unless @installedPageCallback
      @installedPageCallback = true
      $(document).on( 'turbolinks:load', -> App.answers_channel.followCurrenQuestion())