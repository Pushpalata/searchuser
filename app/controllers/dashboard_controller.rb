class DashboardController < ApplicationController

  def index
    if params[:user_name].present?
      @report = Report.get_social_data(params[:user_name])
    end
    respond_to do |format|
      format.html
      format.js
      format.xls
      format.docx do
        render :docx => 'index', :filename => 'user_list.docx'
      end
    end
  end
  
end
