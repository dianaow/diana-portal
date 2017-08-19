class Impression < ActiveRecord::Base
    
belongs_to :impressionable, polymorphic: true, counter_cache: :impressions_count

end