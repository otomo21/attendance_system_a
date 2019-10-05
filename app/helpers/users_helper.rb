module UsersHelper
  # 基本時間などの値を、指定の書式にフォーマットして返す
  def format_basic_time(datetime)
    format("%.2f", ((datetime.hour * 60) + datetime.min)/60.0)
  end
  
  # 指示者確認㊞（勤怠編集） show
  def superior_chk(day)
    unless day.process_kbn == "2"
      return ''
    end
    
    case day.superior_chk_kbn
    when '0' then
      ''
    when '1' then
      '勤怠編集申請中'
    when '2'
      '勤怠編集承認済'
    else
      '勤怠編集否認'
    end
  end
end
