class RenameMessageToCaption < ActiveRecord::Migration
  def change
    rename_column :posts, :message, :caption
  end
end
