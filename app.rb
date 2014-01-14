require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require_relative 'models'

enable :sessions

get '/' do
  @page_title = "Contacts"
  @page_description = "Phonebook Application Example"
  @contacts = Contact.order(:first_name)
  @collections = {}
  letters = @contacts.map { |contact| contact.first_name.chars.first.capitalize }.uniq
  letters.each do |letter|
    @collections[letter.to_sym] = @contacts.map do |contact|
      contact if contact.first_name.chars.first.capitalize == letter
    end.compact!
  end
  erb :contacts
end

get '/new' do
  @page_title = "New Entry"
  @page_description = "Add a new entry to your the phonebook"
  @contact ||= Contact.new # magic
  erb :new
end

post '/create' do
  @contact = Contact.new
  @contact.set_fields(params[:contact], [:first_name, :last_name, :phone_number, :email_address, :full_address, :notes])
  @contact.created_at = Time.now.to_s
  if @contact.valid?
    @contact.save # all good, let's savje the model
    flash[:notice] = "Awesome, the new entry has been added successfully."
    redirect "/"
  else
    @page_title = "New Entry"
    @page_description = "Please try to enter the data again"
    flash.now[:error] = "I tried, but something went wrong."
    erb :new
  end
end

get '/edit/:id' do
  @page_title = "Edit Entry"
  @page_description = "Edit an existing entry"
  @contact = Contact[params[:id].to_i]
  erb :edit
end

post '/update/:id' do
  @contact = Contact[params[:id].to_i]
  @contact.set_fields(params[:contact], [:first_name, :last_name, :phone_number, :email_address, :full_address, :notes])
  @contact.updated_at = Time.now.to_s
  if @contact.valid?
    @contact.save
    flash[:notice] = "The entry has been updated successfully." 
    redirect "/"
  else
    @page_title = "Edit Entry"
    @page_description = "Edit an existing entry"
    flash.now[:error] = "I tried hard, but something went wrong."
    erb :edit
  end
end

get '/delete/:id' do
  # a get request delete route
  @contact = Contact[params[:id].to_i]
  if @contact.delete
    flash[:notice] = "All good, entry deleted."
    redirect '/'
  else
    flash[:error] = "I tried hard, buy couldn't delete the entry."
    redirect '/'
  end
end
