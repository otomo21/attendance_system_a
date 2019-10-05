class RemoveAttendanceIdToAttendanceNews < ActiveRecord::Migration[5.1]
  def change
    remove_index :attendance_news, :attendance_id
    remove_column :attendance_news, :attendance_id, :string
  end
end
