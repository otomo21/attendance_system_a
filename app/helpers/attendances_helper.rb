module AttendancesHelper
  def current_time
    Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min, 0
    )
  end
  
  # 「分」の表示
  def format_min(min)
    if min < "15"
      "00"
    elsif min < "30"
      "15"
    elsif min < "45"
      "30"
    else
      "45"
    end
  end
  
  def working_times(day, mode)
    started_at_min = format_min(day.started_at.to_s(:min))
    
    if mode == "started_at_min"
      return started_at_min
    end
    
    finished_at_min = format_min(day.finished_at.to_s(:min))
    
    workingtime = format("%.2f", (((day.finished_at - day.started_at) / 60) / 60.0))
    
    if mode == "finished_at_min"
      return finished_at_min
    else
      return workingtime.split('.')[0] + "." + format_min(workingtime.split('.')[1])
    end
  end
  
  #def working_times(started_at, finished_at)
  #  format("%.2f", (((finished_at - started_at) / 60) / 60.0))
  #end
  
  def working_times_sum(seconds)
    format("%.2f", seconds)
  end
  
  def first_day(date)
    !date.nil? ? Date.parse(date) : Date.current.beginning_of_month
  end
  
  def user_attendances_month_date
    @user.attendances.where('worked_on >= ? and worked_on <= ?', @first_day, @last_day).order('worked_on')
  end
  
  # 時間の整合性チェック
  def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      elsif item[:started_at] > item[:finished_at]
        attendances = false
        break
      end
    end
    return attendances
  end
  
  # システム日付以降の勤怠編集不可
  def check_day?
    result = true
    attendances_params.each do |id, item|
      attendance = Attendance.find(id)
      
      if item[:started_at].present? && Date.today < attendance.worked_on
        result = false
        break
      end
    end
    
    return result
  end
  
end
