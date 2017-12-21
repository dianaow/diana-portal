module ApplicationHelper

  def nav_items
    [
      {
        icon: 'glyphicon glyphicon-envelope',
        url: conversations_path,
        title: 'My Messages'
      },
      if user_signed_in? == true
      {
        icon: 'glyphicon glyphicon-file',
        url: user_path(current_user),
        title: 'My Articles'
      }
      end,
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
  
  def nav_helper tag_type
    nav_links = ''

    nav_items.each do |item|
    nav_links << "  <li>
                      <#{tag_type} class= '#{item[:icon]}'></#{tag_type}>
                      <#{tag_type}>
                        <a href='#{item[:url]}'>#{item[:title]}</a>
                      </#{tag_type}>
                    </li>"
    end

    nav_links.html_safe
  end




end
