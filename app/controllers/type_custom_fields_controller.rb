class TypeCustomFieldsController < ApplicationController
 
  
  before_filter :get_type_new , :find_project
   
   
    def get_type_new
  @type = TypeCustomFields.new
    end
  
  
     def edit
         @type = TypeCustomFields.find_by_id(params[:id])
         @father = TypeCustomFields.find_by_id(@type.figlia_di)
     end
     
     
      def new
        @type = TypeCustomFields.new
      end
  
    def create
     @type = TypeCustomFields.new(params[:type])
      if @type.save
        flash[:notice] = l(:notice_successful_create)
       redirect_to :controller => 'type_custom_fields', :action => 'gestione'
       else
      render :action => 'new'
      end   
    end


  def update
    @type = TypeCustomFields.find_by_id(params[:id])
    if request.post? and @type.update_attributes(params[:type])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => "gestione"
    else
      render :action => "edit", :id => params[:id]
    end
  end


  def gestione
     respond_to do |format|
        format.html { render :template => 'type_custom_fields/elenco_tipologie', :layout => !request.xhr? }
   end
  end
 
   def destroy
   @customer = TypeCustomFields.find_by_id(params[:id])
    if @customer.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unsuccessful_save)
    end
    redirect_to :controller => 'type_custom_fields', :action => 'gestione'
    end
end