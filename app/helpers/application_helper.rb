module ApplicationHelper

  def nav_items
    [
      {
        icon: 'glyphicon glyphicon-envelope',
        url: conversations_path,
        title: 'My Messages'
      },
      {
        icon: 'glyphicon glyphicon-file',
        url: user_path(current_user),
        title: 'My Articles'
      },
      {
        icon: 'glyphicon glyphicon-star',
        url: followers_path,
        title: 'My Followers'
      },
      {
        icon: 'glyphicon glyphicon-plus',
        url: following_path,
        title:'My Following'
      },
      {
        icon: 'glyphicon glyphicon-pencil',
        url: drafts_path,
        title: 'My Drafts'
      },
    ]
  end
  
  def nav_helper style_wrapper_icon, style_icon, style_wrapper_url, tag_type, icon_tag_type
    nav_links = ''

    nav_items.each do |item|
      nav_links << "<div class= 'row nav-style'>
                      <#{tag_type} class='#{style_wrapper_icon}'>
                        <#{icon_tag_type} class= '#{item[:icon]}' style='#{style_icon}'></#{icon_tag_type}>
                      </#{tag_type}>
                      <#{tag_type} class='#{style_wrapper_url}'>
                        <a href='#{item[:url]}'>#{item[:title]}</a>
                      </#{tag_type}>
                    </div>"
    end

    nav_links.html_safe
  end


  def flash_class(level)
      case level
          when :notice then "alert alert-info"
          when :success then "alert alert-success"
          when :error then "alert alert-error"
          when :alert then "alert alert-error"
      end
  end


end
