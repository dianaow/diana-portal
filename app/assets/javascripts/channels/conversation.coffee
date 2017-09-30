App.conversation = App.cable.subscriptions.create('ConversationChannel',
  connected: ->
  disconnected: ->
  received: (data) ->
    chat_area = $('.chat_area')
    member_list = $('[data-conversation-member=\'' + data['conversation_id'] + '\']')
    conversation = chat_area.find('[data-conversation-id=\'' + data['conversation_id'] + '\']')
    if conversation.length == 0
    else
      if member_list.length
        $('#member_list ul').find(member_list).remove()
      list = '<li class=\'left clearfix\' data-conversation-member= ' + data['conversation_id'] + ' >'
      $('#member_list ul').prepend list
      member_list = $('[data-conversation-member=\'' + data['conversation_id'] + '\']')
      conversation.append data['template']
      member_list.html data['conversation_template']
      height = chat_area[0].scrollHeight
      chat_area.scrollTop height
    return
  speak: (personal_message) ->
    @perform 'speak', personal_message: personal_message
)
$(document).on 'submit', '.new_message', (e) ->
  e.preventDefault()
  values = $(this).serializeArray()
  App.conversation.speak values
  $(this).trigger 'reset'
  return