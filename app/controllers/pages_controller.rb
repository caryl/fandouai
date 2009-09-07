class PagesController < ApplicationController
  def show
    @content = @page = Page.find(params[:id])

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @page }
    end
  end

end
