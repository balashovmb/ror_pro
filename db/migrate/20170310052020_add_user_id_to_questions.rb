class AddUserIdToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :user    
  end
end
