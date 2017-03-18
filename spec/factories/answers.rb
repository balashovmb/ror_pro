FactoryGirl.define do
  sequence :answer_body do |n|
    "Answer body#{n}"
  end

  factory :answer do
    body "MyText12345"
    user
    question
    best false
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    user
    question
    best false    
  end

  factory :answer_list, class: "Answer" do
    body :answer_body
    user
    question
    best false    
  end
end
