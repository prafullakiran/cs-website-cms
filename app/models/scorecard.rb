class Scorecard < ApiModel
  attr_accessor :name, :money_awarded, :submitted_date, :score, :prize_awarded, :place

  def self.api_endpoint
    "challenges"
  end

  def self.has_many_api_endpoint
    api_endpoint
  end    

  def member
    Member.new raw_data.member__r
  end  

  def judges_scores
    if raw_data.scorecard__r
    	raw_data.scorecard__r.records 
    else
      []
    end
  end

  def submission_date_utc
    Time.parse(@submitted_date).getutc if @submitted_date
  end  

end