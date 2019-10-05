class CreateAttendanceNews < ActiveRecord::Migration[5.1]
  def change
    create_table :attendance_news do |t|
      t.date :worked_on
      t.integer :superior_id
      t.string :superior_chk_kbn
      t.string :process_kbn
      t.date :approval_at

      t.timestamps
    end
  end
end
