class AddCoverToAticles < ActiveRecord::Migration
  def change
  	add_attachment :articles, :cover
  end
end
