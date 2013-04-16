require 'rubygems'
require 'sinatra'
require_relative 'gcount.rb'

require 'data_mapper'

#################
# Configuration #
#################

class Gcount
    include DataMapper::Resource
    property :id, Serial
    property :q, String
    property :gcount, Integer
    property :created_at, DateTime
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
end

configure :development do
#  DataMapper.setup(:default, 'sqlite3://mp3links.sqlite3')
  DataMapper.setup(:default, 'sqlite::memory:')
end
DataMapper.finalize

Gcount.auto_upgrade!

get '/hello' do
  "Hello Gcount!"
end

get '/q' do
  obj = Gcount.first(:q => params[:q])
  p "from database: #{obj}"
  if obj.nil?
    p 'not found in database'
    gcount = query_google(params[:q])
    Gcount.create(:q => params[:q], :gcount => gcount, :created_at => Time.now )
    gcount.to_s
  else
    obj.gcount.to_s
  end
end

get '/rq' do
  query_google(params[:q])
end

