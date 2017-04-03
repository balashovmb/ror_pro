FactoryGirl.define do
  factory :vote_up, class: "Vote" do
    value "1"
    user 
    votable 
  end

  factory :vote_down, class: "Vote" do
    value "-1"
    user 
    votable 
  end

end
