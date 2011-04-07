# Use rake db:migrate_plugins to migrate installed plugins
class LinkTypeAndCustomToIssue < ActiveRecord::Migration
  def self.up
    add_column :issues, :type_id, :integer
    add_column :issues, :linked_custom_id, :integer
    add_column :issues, :linked_custom_value_id, :integer
  end

  def self.down
    remove_column :users, :type_id
    remove_column :users, :linked_custom_id
    remove_column :issues, :linked_custom_value_id
  end
end
