module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(user, size: 60)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

end