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
        loveread = Loveread.new(@book_name, params[:book_id])
        @title = loveread.title(params[:p])
        @html_page = loveread.html_page(params[:p])
      rescue
        @html_page = 'Что-то пошло не так'
      end
    else
      @html_page = 'Перед поиском введите название книги'
    end
    erb :index, { :locals => params, :layout => :layout }
  end
end
