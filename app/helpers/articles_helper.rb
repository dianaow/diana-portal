module ArticlesHelper
    
  def display_votes(article)
    votes = article.get_upvotes.size
    votes.to_s + like_plural(votes)
  end
  
  private

  def like_plural(votes)
    return ' votes' if votes > 1 
    ' vote'
  end
  
end
