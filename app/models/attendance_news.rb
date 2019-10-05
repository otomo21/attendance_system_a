class AttendanceNews < ApplicationRecord
  belongs_to :user
  belongs_to :attendance
end
