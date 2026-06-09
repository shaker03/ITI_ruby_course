set :environment, "development"
#call the cleanup task every minute to archive articles that have been reported 6 or more times and delete articles that have been archived for more than 7 days
every 1.minutes do
  rake "articles:cleanup"
end
