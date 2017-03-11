FactoryGirl.define do

  sequence :answer_body do |n|
    "Answer body#{n}"
  end

  factory :answer do
    body "MyText12345"
    user
    question
  end
  
  factory :invalid_answer, class: "Answer" do
    body nil
    user
    question    
  end

  factory :answer_list, class: "Answer" do
    body :answer_body
    user
    question
  end

end
