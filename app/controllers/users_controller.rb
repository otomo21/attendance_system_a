class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_corrent_user, only: [:show]
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    if params[:first_day].nil?
      @first_day = Date.today.beginning_of_month
    else
      @first_day = Date.parse(params[:first_day])
    end
  
    @last_day = @first_day.end_of_month
    
    (@first_day..@last_day).each do |day|
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    
    @dates = user_attendances_month_date
    @worked_sum = @dates.where.not(started_at: nil).count
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      log_in @user
      flash[:success] = "ユーザーの新規作成に成功しました。"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def user_update
    @user = User.find(params[:id])
    if @user.update_attributes(edit_user_params)
      flash[:success] = "#{@user.name}さんのユーザー情報を更新しました。"
      redirect_to action: 'index'
    else
      flash[:danger] = "#{@user.name}さんの更新に失敗しました。"
      redirect_to action: 'index'
    end
  end
  
  def index
    @title = "ユーザー一覧"
    unless params[:search].nil?
      @title = params[:search].empty? ? "ユーザー一覧" : "検索結果"
    end
    
    @page = 15
    @users = User.paginate(page: params[:page], per_page: @page).search(params[:search])
    @user = User.new
  end
  
  def index_user_list
   @page = params[:per]
   @users = User.paginate(page: params[:page], per_page: @page)
   render "index"
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
    @user = User.find(params[:id])
  end
  
  def update_basic_info
    @user = User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to @user   
    else
      render 'edit_basic_info'
    end
  end
  
  def import
    # fileはtmpに自動で一時保存される
    if User.import(params[:file])
      flash[:success] = "CSVを取り込みました。"
    else
      flash[:danger] = "CSVの取り込みに失敗しました。。"
    end
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end
    
    def edit_user_params
      params.require(:user).permit(:name, :email, :department, :employee_number, :uid, :password, :work_time, :designated_work_start_time, :designated_work_end_time)
    end
    
    # beforeアクション

    # ログイン済みユーザーか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    # 管理者または正しいユーザーかどうか
    def admin_corrent_user
      @user = User.find(params[:id])
      if !current_user?(@user) && !current_user.admin?
        redirect_to(root_url) 
      end
    end
end
