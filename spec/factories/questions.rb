FactoryGirl.define do

  sequence :body do |n|
    "Question body#{n}"
  end

  sequence :title do |n|
    "Question title#{n}"
  end  

  factory :question_list, class: "Question" do
    title 
    body 
  end

  factory :question do
    title "Question title"
    body "Question body"
  end  

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
  
end
