class Article < ApplicationRecord
  #article belongs to user(this is how to connect the article to the user)
  belongs_to :user
  #connect the article to the image
  has_one_attached :image
  #callback to check the reports count before saving the article
  before_save :check_reports_count

  private

  def check_reports_count
    # If the article has been reported 6 or more times, it should be archived and can't be return to publuc again
    if self.reports_count >= 6
      self.is_archived = true
      #if the article has been reported 3 times, it should be archived but can be return to public if the owner edit it
    elsif self.reports_count_changed? && self.reports_count == 3
      self.is_archived = true
    end
  end
end
