class AddUpdFlgToAttendanceNews < ActiveRecord::Migration[5.1]
  def change
    add_column :attendance_news, :upd_flg, :boolean, default: false
  end
end
