FactoryGirl.define do
  factory :comment do
    body "MyComment"
    user
    association :commentable, factory: :question
  end
end
