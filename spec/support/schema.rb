ActiveRecord::Schema.define do
  self.verbose = false

  create_table :videos, force: true do |t|
    t.string :zencoder_job_state
    t.integer :zencoder_job_id
    t.timestamps null: false
  end
end
