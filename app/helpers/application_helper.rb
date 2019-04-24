module ApplicationHelper
  # ページごとにタイトルを返す。
  def full_title(page_title = "")
    base_title = "勤怠管理システム"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  # 表示色の変更土曜日は青、日曜日は赤
  def day_color(wday)
    if wday == 0
      "sunday"
    elsif wday == 6
      "saturday"
    end
  end
end
