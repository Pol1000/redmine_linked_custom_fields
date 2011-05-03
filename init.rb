require 'redmine'
require 'linked_fields_hooks'
require 'linked_fields_query_patch'

Redmine::Plugin.register :redmine_linked_custom_fields do
  name 'Redmine Linked Custom Fields plugin'
  author 'Paolo Boldrini'
  description 'implements custom fields that must be interconnected '
  version '0.0.1'
  url ''
  author_url ''
  
Issue.safe_attributes 'linked_custom_id1', 'linked_custom_id2','linked_custom_id3'


 project_module :linked_custom_fields do

    permission :edit_linked_custom_fields, {:linked_custom_fields => [:edit, :update, :new, :create, :gestione, :destroy]}
    permission :edit_custom_type, {:type_custom_fields => [:edit, :update, :new, :gestione, :create, :destroy]}

  
  end
  menu :project_menu, :linked_custom_fields_mod, { :controller => 'linked_custom_fields', :action => 'gestione' }, :caption => 'Valori', :param => :project_id
  menu :project_menu, :type_custom_fields_mod, { :controller => 'type_custom_fields', :action => 'gestione' }, :caption => 'Tipologie', :param => :project_id

end
