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
    user
  end

  factory :question do
    title "Question title"
    body "Question body"
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
