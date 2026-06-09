namespace :articles do
  desc "Remove articles that have 6 or more reports"
  task cleanup: :environment do
    # Find all articles with 6 or more reports and delete them
    bad_articles = Article.where("reports_count >= ?", 6)
    count = bad_articles.count
    bad_articles.destroy_all

    puts "Cleanup complete: #{count} articles removed."
  end
end
