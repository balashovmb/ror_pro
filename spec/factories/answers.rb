FactoryGirl.define do
  factory :answer do
    body "MyText12345"
  end
  
  factory :invalid_answer, class: "Answer" do
    body nil
  end

end
