# Use rake db:migrate_plugins to migrate installed plugins
class LinkTypeAndCustomToIssue < ActiveRecord::Migration
  def self.up
    add_column :issues, :linked_custom_id1, :integer
    add_column :issues, :linked_custom_id2, :integer
    add_column :issues, :linked_custom_id3, :integer
  end

  def self.down
    remove_column :issues, :linked_custom_id1
    remove_column :issues, :linked_custom_id2
    remove_column :issues, :linked_custom_id3
  end
end
