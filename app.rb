require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'erb'

%w(lib).each { |p| Dir[File.join(File.dirname(__FILE__), p, "*.rb")].each { |file| require file } }

configure do
  set :bind, '0.0.0.0'
end

class BookSaver < Sinatra::Base
  get '/' do
    if params[:book_name] && params[:book_name].length > 0
      @book_name = params[:book_name]
      begin
        @html_page = Loveread.new(@book_name).html_page(params[:p])
      rescue
        @html_page = 'Something went wrong'
      end
    else
      @html_page = 'Please fill book name before search'
    end
    erb :index, { :locals => params, :layout => :layout }
  end
end
