class CreatePlatformPriorities < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_priorities do |t|
      t.uuid :guid
      t.string :description
      t.references :project, null: false, foreign_key: true


      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_priorities_on_guid_project"      
    end
  end
end
