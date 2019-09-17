class BasesController < ApplicationController
  def new
    @base = Base.new
  end
  
  def index
    @bases = Base.all.order('base_number')
  end

  def create
    @base = Base.new(base_params)
    
    if @base.save
      redirect_to action: 'index'
    else
      render "new"
    end
  end
  
  def edit
    @base = Base.find(params[:id])
  end
  
  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = "#{@base.name}の拠点情報を更新しました。"
      redirect_to action: 'index'
    else
      render "edit"
    end
  end
  
  def destroy
    @base = Base.find(params[:id])
    @base.destroy
    flash[:success] = "#{@base.name}の拠点情報を削除しました。"
    redirect_to bases_url
  end

  private
    def base_params
      params.require(:base).permit(:base_number, :name, :attendance_type)
    end
    
end