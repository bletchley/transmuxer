class AddTransmuxerTo<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    change_table(:<%= table_name %>) do |t|
      t.integer :zencoder_job_id
      t.string :zencoder_job_state
    end

    add_index :<%= table_name %>, :zencoder_job_id, unique: true
  end

  def self.down
    change_table(:<%= table_name %>) do |t|
      t.remove :zencoder_job_id, :zencoder_job_state
    end
  end
end