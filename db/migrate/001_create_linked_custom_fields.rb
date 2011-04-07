class CreateLinkedCustomFields < ActiveRecord::Migration
  def self.up
    create_table :linked_custom_fields do |t|
      t.column :tipologia, :integer
      t.column :valore, :string, :null => false
      t.column :figlia_di, :integer
   end
    create_table :type_custom_fields do |t|
      t.column :riferimento, :string, :null => false
      t.column :descrizione, :string, :null => false
      t.column :figlia_di, :integer
    end

  #add a foreign key
    execute <<-SQL
      ALTER TABLE type_custom_fields
        ADD CONSTRAINT fk_01_figlia_di
        FOREIGN KEY (figlia_di)
        REFERENCES type_custom_fields(id)
    SQL

 #add a foreign key
    execute <<-SQL
      ALTER TABLE linked_custom_fields
        ADD CONSTRAINT fk_00_type
        FOREIGN KEY (tipologia)
        REFERENCES type_custom_fields(id)
    SQL
  #add a foreign key
    execute <<-SQL
      ALTER TABLE linked_custom_fields
        ADD CONSTRAINT fk_00_figlia_di
        FOREIGN KEY (figlia_di)
        REFERENCES linked_custom_fields(id)
    SQL
  end

  def self.down
    drop_table :linked_custom_fields
    execute "ALTER TABLE linked_custom_fields DROP FOREIGN KEY fk_00_type"
    drop_table :type_custom_fields
  end
end
