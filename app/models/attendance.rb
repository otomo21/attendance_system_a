class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validate :started_at_none
  validate :attendance_comparison
  validate :check_day
  
  
  private
    # 退勤時間は出勤時間がある場合のみ登録可
    def started_at_none
      if finished_at.present? && started_at.nil? 
       errors.add(:finished_at, "出勤していません。")
      end
    end
    
    # 退勤時間は出勤時間より前は登録不可
    def attendance_comparison
      if finished_at.present? && started_at >= finished_at
        errors.add(:finished_at, "退勤時刻は出勤時刻より早い時間は設定できません。")
      end
    end
    
    # システム日付以降の勤怠編集は不可
    def check_day
      if Date.today < worked_on
        errors.add(:worked_on, "本日以降の勤怠編集はできません。")
      end
    end
end
