require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'erb'

%w(lib).each { |p| Dir[File.join(File.dirname(__FILE__), p, "*.rb")].each { |file| require file } }

configure do
  set :bind, '0.0.0.0'
end

class BookSaver < Sinatra::Base
  get '/download' do
    loveread = Loveread.new(params[:book_name], params[:book_id], params[:author])
    loveread.send(params[:format])
    content_type "application/#{params[:format]}"
    attachment "./#{loveread.title(1, false)}.#{params[:format]}"
    send_file "./#{loveread.title(1, false)}.#{params[:format]}"
  end

  get '/' do
    if params[:book_name] && params[:book_name].length > 0
      @book_name = params[:book_name]
      begin
        loveread = Loveread.new(@book_name, params[:book_id], params[:author])
        @title = loveread.title(params[:p])
        @book_id = loveread.book_id
        @author = loveread.author
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
