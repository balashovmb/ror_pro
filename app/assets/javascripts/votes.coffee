vote_success = (e, data, status, xhr) ->
    votable = $.parseJSON(xhr.responseText)
    dom_id = votable.dom_id
    $('#rating_' + dom_id).html('<p>Rating: ' + votable.rating + '</p>')    
    $('.question-vote-errors').html('')
    console.log('#rating_' + dom_id)

vote_error = (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $('.vote-errors').html('<p>' + response.data + '</p>')   


$(document).on 'ajax:success', '.voting', vote_success
$(document).on 'ajax:error', '.voting', vote_error