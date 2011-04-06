class LinkedFieldsHooks < Redmine::Hook::ViewListener
 
 def view_issues_form_details_bottom(params)
        html = ""
        html += "<p>"
        html += params[:form].select :id, TypeCustomFields.find(:all, :conditions => {:riferimento => "issue"}).collect{ |t| [t.descrizione, t.id]}, :include_blank => true
        html += params[:form].select :id, LinkedCustomFields.find(:all, :conditions => {:tipologia => type.id}).collect{ |l| [l.valore, l.id]}, :include_blank => true
        html += "</p>"
        html
        # user = params[:user]
        # "ciao"
    end
    
end