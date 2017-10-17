module ArticlesHelper
    
  def sort_items
    [
      {
        search_params: @q,
        attribute: :created_at,
        label: 'Created Date'
      },
      {
        search_params: @q,
        attribute: :categories_name,
        label: 'Category'
      },
      {
        search_params: @q,
        attribute: :impressions_count,
        label:'View Count'
      },
      {
        search_params: @q,
        attribute: :cached_votes_up,
        label: 'Highest Rated'
      },
    ]
  end
  
  def sort_helper 
    sort_links = ''

    sort_items.each do |item|
      sort_links << "<div class= 'col-md-2'>
                      <%= sort_link(@q, :#{item[:attribute]}) do %>
                         <div class='panel panel-default'>
                            <div class='panel-body'>
                              <p>#{item[:label]}</p>
                            </div>
                         </div>
                      <% end %>
                    </div>"
    end
   sort_links.html_safe
  end
  
  def title_helper(styles)
    if item[:attribute]
       greeting = "Search Results for articles containing: #{item[:attribute]}, "
      content_tag(:div, greeting.html_safe, class: styles)
    end
  end
  
  def get_query(cookie_key)
    cookies.delete(cookie_key) if params[:clear]
    cookies[cookie_key] = params[:q].to_json if params[:q]
    @query = params[:q].presence || JSON.load(cookies[cookie_key])
  end

end
