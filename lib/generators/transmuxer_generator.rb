require "rails/generators/active_record"

class TransmuxerGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path "../templates", __FILE__

  def copy_migration
    migration_template "migration.rb", "db/migrate/add_transmuxer_to_#{table_name}.rb"
  end
end