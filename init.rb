require 'redmine'
require 'linked_fields_hooks'

Redmine::Plugin.register :redmine_linked_custom_fields do
  name 'Redmine Linked Custom Fields plugin'
  author 'Paolo Boldrini'
  description 'implements custom fields that must be interconnected '
  version '0.0.1'
  url ''
  author_url ''

settings :default => {
       'statuses' => []
  }, :partial => 'settings/redmine_linked_custom_fields_settings'

end
