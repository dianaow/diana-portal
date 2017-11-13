module ArticlesHelper
    
  def display_likes(article)
    votes = article.votes_for.up.by_type(User)
    count_likers(votes)
  end
  
  private

  def count_likers(votes)
    vote_count = votes.size
    vote_count.to_s +  'likes'
  end
  
  def like_plural(votes)
    return 'like this' if votes.count > 1
    'likes this'
  end
  
end
