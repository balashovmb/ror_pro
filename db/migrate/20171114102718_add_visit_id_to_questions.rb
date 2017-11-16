class AddVisitIdToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :visit_id, :integer    
  end
end
