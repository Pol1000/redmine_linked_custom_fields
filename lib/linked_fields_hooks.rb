class LinkedFieldsHooks < Redmine::Hook::ViewListener
 include ActionView::Helpers::PrototypeHelper
 
 def view_issues_form_details_bottom(params)
        html = ""
        html += "<p>"
        html += params[:form].select :type_id, TypeCustomFields.find(:all, :conditions => {:riferimento => "issue"}).collect{ |t| [t.descrizione, t.id]}, :include_blank => true
        html += "</p>"
        html += "<p>"
        html += observe_field :issue_type_id, :url => {:controller => 'linked_custom_fields', :action => :update_form_issue1},
                                     :update => :primo_select,
                                     :with => :type_id              
       html += "<div id='primo_select'></div>"
        html += "</p>"
        html
       
    end
    # select :linked_custom_id, LinkedCustomFields.find(:all, :conditions => {:tipologia => :type_id}).collect{ |l| [l.valore, l.id]}, :include_blank => true
 def protect_against_forgery?
    false
   end
end