class HelloChannel < ActionCable::Channel::Base
  def say_hello(data)
    times_to_say_hello = data.fetch("times_to_say_hello")
    hello = "Hello, #{current_profile.name}!"

    times_to_say_hello.times do
      ActionCable.server.broadcast(current_profile.id, hello)
    end
  end
end