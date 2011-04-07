class LinkedCustomFieldsController < ApplicationController
 before_filter :get_custom_new
   
    def get_custom_new
  @custom = LinkedCustomFields.new
end


  def edit
         @edit_custom = LinkedCustomFields.find_by_id(params[:id])
         @tipologia = TypeCustomFields.find_by_id(@edit_custom.tipologia)
         @son_of = LinkedCustomFields.find_by_id(@edit_custom.figlia_di)
     end

      def new
        @custom = LinkedCustomFields.new
      end
  
    def create
     @custom = LinkedCustomFields.new(params[:custom])
      if @custom.save
        flash[:notice] = l(:notice_successful_create)
       redirect_to :controller => 'linked_custom_fields', :action => 'gestione'
       else
      render :action => 'new'
      end   
    end


  def update
    @custom = LinkedCustomFields.find_by_id(params[:id])
    if request.post? and @custom.update_attributes(params[:custom])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => "gestione"
    else
      render :action => "edit", :id => params[:id]
    end
  end


   def destroy
   @custom = LinkedCustomFields.find_by_id(params[:id])
    if @custom.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unsuccessful_save)
    end
    redirect_to :controller => 'linked_custom_fields', :action => 'gestione'
    end

 def filtra_padre_per_categoria
   @filtered_padre = LinkedCustomFields.find(:all, :conditions =>{:tipologia => params[:tipologia]})
    render :layout => false
 end

 def update_form_issue1
   @filtered_custom =LinkedCustomFields.find(:all, :conditions => {:tipologia => params[:type_id]})
     render :layout => false
 end
 
 def update_form_issue2
   @father_filtered_custom =LinkedCustomFields.find(:all, :conditions => {:figlia_di => params[:linked_custom_id]})
     render :layout => false
 end


  def gestione
     respond_to do |format|
        format.html { render :template => 'linked_custom_fields/elenco_valori', :layout => !request.xhr? }
   end
 end
  end
