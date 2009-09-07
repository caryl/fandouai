class AuthorsController < ApplicationController
  def index
    @authors = Author.paginate(:page=>params[:page]||1)

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @authors }
    end
  end
end
