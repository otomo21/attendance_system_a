class AttendancesController < ApplicationController
  before_action :admin_corrent_user, only: [:edit]
  before_action :month_inf, only: [:edit, :month_application]
  
  def create
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find_by(worked_on: Date.today)
    if @attendance.started_at.nil?
      @attendance.update_attributes(started_at: current_time)
      flash[:info] = 'おはようございます。'
    elsif @attendance.finished_at.nil?
      @attendance.update_attributes(finished_at: current_time)
      flash[:info] = 'おつかれさまでした。'
    else
      flash[:danger] = 'トラブルがあり、登録出来ませんでした。'
    end
    redirect_to @user
  end
  
  def edit
    # 上長抽出
    @superior = User.where(superior: true)
  end
  
  def update
    @user = User.find(params[:id])
    if attendances_invalid?
      unless check_day?
        flash[:danger] = "本日以降の勤怠情報は変更できません。"
        redirect_to edit_attendances_path(@user, params[:date])
        return
      end
      
      result = false
      
      attendances_params.each do |id, item|
        if item[:update_kbn] == "1"
          attendance = Attendance.find(id)
          attendance.update_attributes(started_at: item[:started_at], finished_at: item[:finished_at], note: item[:note],
                                       superior_id: item[:superior_id], next_day_flag: item[:next_day_flag],
                                       superior_chk_kbn: item[:superior_id].blank? ? "0": "1", process_kbn: "2", before_started_at: attendance.started_at,
                                       before_finished_at: attendance.finished_at, after_started_at: item[:started_at], after_finished_at: item[:finished_at])
          #申請は何度でも可能だが、それがカウントされないようにする
          attendance_news_del = AttendanceNews.find_by(attendance_id: id, del_flg: "0")
          
          unless attendance_news_del.nil?
            attendance_news_del.update_attributes(del_flg: "1")
          end
    
          @attendance_news = AttendanceNews.new(worked_on: attendance.worked_on, superior_id: item[:superior_id], superior_chk_kbn: '1',
                                                process_kbn: '2', user_id: attendance.user_id, attendance_id: id)
          @attendance_news.save
          
          result = true
        end
      end
      
      if result == false
        flash[:warning] = '変更するデータにチェックを入れてください'
        redirect_to edit_attendances_path(@user, params[:date])
        return
      end
      
      flash[:success] = '勤怠情報を更新しました。'
      redirect_to user_path(@user, params:{first_day: params[:date]})
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to edit_attendances_path(@user, params[:date])
    end
  end
  
  # 申請
  def month_application
    attendanceid = 0
    (@first_day..@last_day).each do |day|
      @attendance = @user.attendances.find_by(worked_on: day)
      
     if @first_day == day
       attendanceid = @attendance.id
     end
    
      @attendance.update_attributes(superior_id: params[:superior_id], superior_chk_kbn: '1', process_kbn: '1')
    end
    
    #申請は何度でも可能だが、それがカウントされないようにする
    attendance_news_del = AttendanceNews.find_by(attendance_id: attendanceid, superior_chk_kbn: '1', process_kbn: '1', del_flg: false)
    
    unless attendance_news_del.nil?
      attendance_news_del.update_attributes(del_flg: "1")
    end
    
    @attendance_news = AttendanceNews.new(worked_on: @first_day, superior_id: params[:superior_id], superior_chk_kbn: '1',
                                          process_kbn: '1', user_id: params[:id], attendance_id: attendanceid)
    @attendance_news.save
    
    flash[:success] = '勤怠情報の承認を申請しました。'
    redirect_to current_user
  end
  
  # 申請承認
  def approval_application
    result = false
    
    attendance_news_params.each do |id, item|
      attendance_news = AttendanceNews.find(id)
      
      # 変更チェックありかつ指示者確認㊞が「申請中」以外
      if item[:upd_flg] == "1" && item[:superior_chk_kbn] != "1"
        attendance_news.update_attributes(superior_chk_kbn: item[:superior_chk_kbn], approval_at: current_time, del_flg: "1")
        
        @first_day = attendance_news.worked_on
        @last_day = @first_day.end_of_month
        
        (@first_day..@last_day).each do |day|
          @attendance = Attendance.find_by(user_id: attendance_news.user_id, worked_on: day)
          @attendance.update_attributes(superior_chk_kbn: item[:superior_chk_kbn], approval_at: current_time)
          attendance_log_create(@attendance)
        end
        
        result = true
      end
    end
    
    if result
      flash[:success] = '勤怠情報を承認しました。'
    else
      flash[:warning] = '承認するデータにチェックを入れてください'
    end
    
    redirect_to current_user
  end
  
  #変更承認
  def approval_upd
    result = false
    
    attendance_news_params.each do |id, item|
      attendance_news = AttendanceNews.find(id)
      
      # 変更チェックありかつ指示者確認㊞が「申請中」以外
      if item[:upd_flg] == "1" && item[:superior_chk_kbn] != "1"
        attendance_news.update_attributes(superior_chk_kbn: item[:superior_chk_kbn], approval_at: current_time, del_flg: "1")
        
        @attendance = Attendance.find(attendance_news.attendance_id)
        
        @attendance.update_attributes(rireki_num: @attendance.rireki_num + 1, superior_chk_kbn: item[:superior_chk_kbn], approval_at: current_time)
        
        attendance_log_create(@attendance)
        result = true
      end
    end
    
    if result
      flash[:success] = '勤怠情報を承認しました。'
    else
      flash[:warning] = '承認するデータにチェックを入れてください'
    end
    
    redirect_to current_user
  end
  
  private
    def attendances_params
      params.permit(attendances: [:started_at, :finished_at, :note, :superior_id, :next_day_flag, :update_kbn])[:attendances]
    end
    
    def attendance_news_params
      params.permit(attendance_news: [:superior_chk_kbn, :upd_flg])[:attendance_news]
    end
    
    def attendance_log_create(attendance)
      attendance_log = AttendanceLog.new(worked_on: attendance.worked_on, started_at: attendance.started_at, finished_at: attendance.finished_at,
                                         note: attendance.note, user_id: attendance.user_id, attendance_id: attendance.id,
                                         rireki_num: attendance.rireki_num, superior_id: attendance.superior_id, superior_chk_kbn: attendance.superior_chk_kbn,
                                         process_kbn: attendance.process_kbn, approval_at: attendance.approval_at, update_kbn: attendance.update_kbn,
                                         before_started_at: attendance.before_started_at, before_finished_at: attendance.before_finished_at,
                                         after_started_at: attendance.after_started_at, after_finished_at: attendance.after_finished_at,
                                         end_estimated_time: attendance.end_estimated_time, next_day_flag: attendance.next_day_flag, job_content: attendance.job_content)
      attendance_log.save
    end
    
    # beforeアクション
    # 管理者または正しいユーザーかどうか
    def admin_corrent_user
      @user = User.find(params[:id])
      if !current_user?(@user) && !current_user.admin?
        redirect_to(root_url) 
      end
    end
    
    def month_inf
      @user = User.find(params[:id])
      @first_day = Date.parse(params[:date])
      @last_day = @first_day.end_of_month
      @dates = user_attendances_month_date
    end
end
