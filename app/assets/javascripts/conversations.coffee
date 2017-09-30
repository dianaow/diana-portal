jQuery(document).on 'turbolinks:load', ->
  messages = $('#conversation-body')
  if messages.length > 0
    messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))

    messages_to_bottom()
  
jQuery(document).on 'init:users_select', ->
  $('.users_select').select2
    width: '100%'
    placeholder: 'Search user'
    ajax:
      url: '/users/search'
      dataType: 'json'
      quietMillis: 100
      data: (term, page) ->
        { q: term }
      processResults: (data, page) ->
        { results: $.map(data.users || [] , (item) ->
          {
            text: item.email
            slug: item.name
            id: item.id
          }
      ) }
    formatResult: (user) ->
      '<div class=\'select2-user-result\'> <span>'+ user.name + '</span><p>'+ user.email + ' ' +  '</p></div>'

jQuery(document).on 'change', 'select.topESelect', () ->
  $.ajax(
    url: $(this).data('url') + '?type=' + this.value
    type: 'GET'
    contentType: 'script'
    processData: false
  )
  return
