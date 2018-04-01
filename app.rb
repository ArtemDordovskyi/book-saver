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
    loveread = Loveread.new(params[:book_name], params[:book_id])
    loveread.send("to_#{params[:format]}")
    book_name = loveread.title(1, false)
    content_type "application/#{params[:format]}"
    attachment "./#{book_name}.#{params[:format]}"
    send_file "./#{book_name}.#{params[:format]}"
  end

  get '/' do
    if params[:book_name] && params[:book_name].length > 0
      @book_name = params[:book_name]
      begin
        loveread = Loveread.new(@book_name, params[:book_id])
        @title = loveread.title(params[:p])
        @book_id = loveread.book_id
        @author = loveread.author
        @html_page = loveread.html_page(params[:p])
        if @book_id.is_a?(Integer)
          aldebaran = Aldebaran.new(@book_name)
          @links = aldebaran.links
        end
      rescue => e
        @html_page = 'Что-то пошло не так'
      end
    else
      @html_page = 'Перед поиском введите название книги'
    end
    erb :index, { :locals => params, :layout => :layout }
  end
end
