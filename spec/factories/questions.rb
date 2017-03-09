FactoryGirl.define do

  sequence :body do |n|
    "Question body#{n}"
  end

  sequence :title do |n|
    "Question title#{n}"
  end  

  factory :question do
    title 
    body
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
  
end
