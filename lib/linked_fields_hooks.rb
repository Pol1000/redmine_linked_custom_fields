class LinkedFieldsHooks < Redmine::Hook::ViewListener
    
    def view_issues_form_details_bottom(params)
       user = params[:user]
        "ciao"+user
    end
    
end