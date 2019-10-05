class AddReferencesToAttendanceNews < ActiveRecord::Migration[5.1]
  def change
    add_reference :attendance_news, :user, index: true
    add_reference :attendance_news, :attendance, index: true
  end
end
