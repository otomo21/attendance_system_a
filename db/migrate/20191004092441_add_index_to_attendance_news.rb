class AddIndexToAttendanceNews < ActiveRecord::Migration[5.1]
  def change
    add_reference :attendance_news, :attendance, index: true
  end
end
