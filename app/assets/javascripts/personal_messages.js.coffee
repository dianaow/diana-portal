class PersonalMessages
  constructor: ->
    @personal_messages = $("[data-behavior='personal_message']")

    if @personal_messages.length > 0
      @handleSuccess @personal_messages.data("personal_message")
      $("[data-behavior='personal_message-link']").on "click", @handleClick

      setInterval (=>
        @getNewpersonal_messages()
      ), 5000

  getNewpersonal_messages: ->
    $.ajax(
      url: "/personal_message.json"
      dataType: "JSON"
      method: "GET"
      success: @handleSuccess
    )

  handleClick: (e) =>
    $.ajax(
      url: "/personal_messages/mark_as_read"
      dataType: "JSON"
      method: "POST"
      success: ->
        $("[data-behavior='unread-count']").text(0)
    )

    unread_count = 0
    $.each data, (i, personal_messages) ->
      if personal_messages.unread
        unread_count += 1

    $("[data-behavior='unread-count']").text(unread_count)

jQuery ->
  new PersonalMessages