class AddColumnToattendanceLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :attendance_logs, :rireki_num, :integer, default:1, null: false
    add_column :attendance_logs, :superior_id, :integer
    add_column :attendance_logs, :superior_chk_kbn, :char, limit: 2
    add_column :attendance_logs, :process_kbn, :char, limit: 2
    add_column :attendance_logs, :approval_at, :date
    add_column :attendance_logs, :update_kbn, :boolean
    add_column :attendance_logs, :before_started_at, :datetime
    add_column :attendance_logs, :before_finished_at, :datetime
    add_column :attendance_logs, :after_started_at, :datetime
    add_column :attendance_logs, :after_finished_at, :datetime
    add_column :attendance_logs, :end_estimated_time, :datetime
    add_column :attendance_logs, :next_day_flag, :boolean
    add_column :attendance_logs, :job_content, :string
  end
end
