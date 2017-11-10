require "rails_helper"

# This is the minimal ActionCable connection stub to make the test pass
class TestConnection
  attr_reader :identifiers, :logger

  def initialize(identifiers_hash = {})
    @identifiers = identifiers_hash.keys
    @logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(StringIO.new))

    # This is an equivalent of providing `identified_by :identifier_key` in ActionCable::Connection::Base subclass
    identifiers_hash.each do |identifier, value|
      define_singleton_method(identifier) do
        value
      end
    end
  end
end

RSpec.describe HelloChannel do
  subject(:channel) { described_class.new(connection, {}) }

  let(:current_profile) { double(id: "1", name: "Bob") }

  # Connection is `identified_by :current_profile`
  let(:connection) { TestConnection.new(current_profile: current_profile) }

  let(:action_cable) { ActionCable.server }

  # ActionCable dispatches actions by the `action` attribute.
  # In this test we assume the payload was successfully parsed (it could be a JSON payload, for example). 
  let(:data) do
    {
      "action" => "test_action",
      "times_to_say_hello" => 3
    }
  end

  it "broadcasts 'Hello, Bob!' 3 times"  do
    expect(action_cable).to receive(:broadcast).with("1", "Hello, Bob!").exactly(3).times

    channel.perform_action(data)
  end
end