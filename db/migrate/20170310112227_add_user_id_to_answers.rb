class AddUserIdToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_reference :answers, :user     
  end
end
