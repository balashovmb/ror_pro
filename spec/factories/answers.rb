FactoryGirl.define do
  factory :answer do
    body "MyText12345"
    user
  end
  
  factory :invalid_answer, class: "Answer" do
    body nil
    user
  end

end
