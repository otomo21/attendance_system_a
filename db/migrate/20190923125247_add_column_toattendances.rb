class AddColumnToattendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :rireki_num, :integer, default:1, null: false
    add_column :attendances, :superior_id, :integer
    add_column :attendances, :superior_chk_kbn, :char, limit: 1
    add_column :attendances, :process_kbn, :char, limit: 1
    add_column :attendances, :approval_at, :date
    add_column :attendances, :update_kbn, :boolean
    add_column :attendances, :before_started_at, :datetime
    add_column :attendances, :before_finished_at, :datetime
    add_column :attendances, :after_started_at, :datetime
    add_column :attendances, :after_finished_at, :datetime
    add_column :attendances, :end_estimated_time, :datetime
    add_column :attendances, :next_day_flag, :boolean
    add_column :attendances, :job_content, :string
  end
end
