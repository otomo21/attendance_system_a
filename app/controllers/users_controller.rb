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
    
    # 月のデータがなければ作成する
    (@first_day..@last_day).each do |day|
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    
    @dates = user_attendances_month_date
    @worked_sum = @dates.where.not(started_at: nil).count
    
    #月初の承認情報を取得
    @approval_inf = Attendance.find_by(user_id: params[:id], worked_on: @first_day)
    
    unless @approval_inf.superior_chk_kbn == "0"
      @approval_superior = User.find_by(id: @approval_inf.superior_id)
    end
    
    # 上長抽出
    @superior = User.where(superior: true)
    
    # 承認申請を抽出
    @approval_application_count = AttendanceNews.where(superior_id: params[:id], superior_chk_kbn: '1', process_kbn: '1', del_flg: false).count
    @approval_upd_count = AttendanceNews.where(superior_id: params[:id], superior_chk_kbn: '1', process_kbn: '2', del_flg: false).count
    #@test = User.all.includes(:attendance_news).where(attendance_news: {superior_id: params[:id], superior_chk_kbn: '1'}).order('employee_number')
    
    query = "select  users.*,
                     attendances.*,
                     attendance_news.*
             from    users,
                     attendances,
                     attendance_news
             where   users.id = attendance_news.user_id
             and     users.id = attendances.user_id
             and     attendances.id = attendance_news.attendance_id
             and     attendance_news.del_flg = ?
             and     attendance_news.process_kbn = ?
             and     attendance_news.superior_id = ?
             and     attendance_news.superior_chk_kbn = ?
             order by users.employee_number,
                      users.id,
                      attendance_news.worked_on"
    @approval_application = AttendanceNews.find_by_sql([query, false, "1", params[:id], "1"])
    @approval_upd = AttendanceNews.find_by_sql([query, false, "2",params[:id], "1"])
  end
  
  def show_confirmation
    @user = User.find(params[:application_id])
    @first_day = Date.parse(params[:date])
    @last_day = @first_day.end_of_month
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
    @user = User.find(params[:id])
    User.find(params[:id]).destroy
    flash[:success] = "#{@user.name}さんのユーザー情報を削除しました。"
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
  
  def work_now
    @work_now = User.all.includes(:attendances).where(attendances: {worked_on:Date.today}).order('employee_number')
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
