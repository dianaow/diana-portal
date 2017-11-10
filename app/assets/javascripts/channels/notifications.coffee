App.notifications = App.cable.subscriptions.create "NotificationsChannel",

  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#notificationList').prepend "#{data.notification}"
    $('#notifications-index-list').prepend "#{data.notification}"
    this.update_counter(data.counter)
    
  update_counter: (counter) ->
    $counter = $('#notification-counter')
    val = parseInt $counter.text()
    val++
    $counter
    .text(val)