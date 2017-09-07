namespace :delete_sessions do

desc "clear sessions every day"
task :clear_expired_sessions => :environment do
    sql = "DELETE FROM sessions WHERE updated_at < (CURRENT_TIMESTAMP - INTERVAL '1 days');"
    ActiveRecord::Base.connection.execute(sql)
end

end
