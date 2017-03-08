FactoryGirl.define do
  factory :question do
    title "MyString123"
    body "MyText12345"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
  
end
