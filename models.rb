require "rubygems"
require 'sequel'

Sequel::Model.plugin(:schema)
DB = Sequel.sqlite('database.db')

unless DB.table_exists? (:contacts)
  DB.create_table :contacts do
    primary_key :id
    string      :first_name, :null => false
    string      :last_name
    string      :phone_number
    string      :email_address
    text        :full_address
    text        :notes
    string      :avatar_file
    timestamp   :created_at
    timestamp   :updated_at
  end
end

class Contact < Sequel::Model(:contacts)
  # Contact Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:first_name, :email_address]
    validates_format /^.+@.+$/, :email_address, :allow_blank=>true
  end

  def pretty_names(field)
    field.split('_').join(' ').capitalize
  end

end