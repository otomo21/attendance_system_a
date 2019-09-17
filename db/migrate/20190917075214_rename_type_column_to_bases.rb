class RenameTypeColumnToBases < ActiveRecord::Migration[5.1]
  def change
    rename_column :bases, :type, :attendance_type
  end
end
