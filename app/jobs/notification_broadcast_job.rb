class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(counter, notification)
    user = notification.recipient
    ActionCable.server.broadcast "notifications-#{user.id}",  counter: render_counter(counter), notification: render_notification(notification)
  end

  private

  def render_counter(counter)
    ApplicationController.renderer.render(partial: 'notifications/counter', locals: { counter: counter })
  end

  def render_notification(notification)
    ApplicationController.renderer.render(partial: 'notifications/notification', locals: { notification: notification })
  end
end