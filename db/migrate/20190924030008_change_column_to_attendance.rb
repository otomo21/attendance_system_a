class ChangeColumnToAttendance < ActiveRecord::Migration[5.1]
  # 変更内容
  def up
    change_column :attendances, :superior_chk_kbn, :string, default: '0', comment: '0:なし,1:申請中,2:承認,3:否認'
    change_column :attendances, :process_kbn, :string, comment: '0:個別,1:一括,2:変更,3:残業'
    change_column :attendances, :update_kbn, :boolean, default: false, comment: 'false:なし,true:あり　（変更）'
  end

  # 変更前の状態
  def down
    change_column :attendances, :superior_chk_kbn, :string
    change_column :attendances, :process_kbn, :string
    change_column :attendances, :update_kbn, :boolean
  end
end
