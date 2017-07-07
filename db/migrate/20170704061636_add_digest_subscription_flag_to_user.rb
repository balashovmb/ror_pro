class AddDigestSubscriptionFlagToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :digest_subscription, :boolean, default: true
  end
end
