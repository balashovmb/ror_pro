vote_success = (e, data, status, xhr) ->
    console.log 'vote done!' 
    votable = $.parseJSON(xhr.responseText)
    dom_id = votable.dom_id
    $('#rating_' + dom_id).html( votable.rating )    
    $('#errors_' + dom_id ).html('')
    votable_v = $(this).parent()
    console.log dom_id


vote_error = (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $('#errors_' + response.dom_id ).html(response.data)

$(document).on 'ajax:success', '.voting', vote_success
$(document).on 'ajax:error', '.voting', vote_error