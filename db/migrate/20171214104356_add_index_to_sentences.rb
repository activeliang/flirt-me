class AddIndexToSentences < ActiveRecord::Migration[5.1]
  def change
    add_index :sentences, :sequence
  end
end
