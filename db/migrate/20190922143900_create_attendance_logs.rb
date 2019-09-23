class CreateAttendanceLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :attendance_logs do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :note
      t.references :user, foreign_key: true
      t.references :attendance, foreign_key: true

      t.timestamps
    end
  end
end
