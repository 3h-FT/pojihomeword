class AddIsSeededToTargetsAndSituations < ActiveRecord::Migration[8.0]
  def change
    add_column :targets, :is_seeded, :boolean, default: false, null: false
    add_column :situations, :is_seeded, :boolean, default: false, null: false
  end
end