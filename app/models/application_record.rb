class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
    def self.ransackable_scopes(auth_object = nil)
        [:categories_name_cont]
    end
end
