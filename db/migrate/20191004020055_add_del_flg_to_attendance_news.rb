class AddDelFlgToAttendanceNews < ActiveRecord::Migration[5.1]
  def change
    add_column :attendance_news, :del_flg, :boolean, default: false
  end
end
