ActiveRecord::Schema.define do
  self.verbose = false

  create_table :videos, force: true do |t|
    t.string :zencoder_job_state
    t.timestamps null: false
  end
end
