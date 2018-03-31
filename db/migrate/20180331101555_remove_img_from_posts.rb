class RemoveImgFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :img, :text
  end
end
