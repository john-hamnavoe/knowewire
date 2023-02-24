class CreatePlatformInvoiceCycles < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_invoice_cycles do |t|
      t.references :project, null: false, foreign_key: true

      t.string :description
      t.boolean :is_deleted
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_invoice_cycle_on_guid_project"
    end
  end
end
