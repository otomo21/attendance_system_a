class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validate :started_at_none
  validate :attendance_comparison
  
  
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
end
