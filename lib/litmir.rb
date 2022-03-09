require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'
require 'html_to_plain_text'
require 'eeepub'

class Litmir
  SEARCH = "https://www.livelib.ru/find/"

  def initialize(book_name, book_id)
    @book_name = book_name
    @doc = get_doc
    @book_id = book_id ? book_id.to_i : get_book_id
    @book_info_page = get_book_info_page if @book_id.is_a?(Integer)
    @author = get_author if @book_id.is_a?(Integer)
  end

  protected
  def get_doc
    url = SEARCH + @book_name
    Nokogiri::HTML(open(URI.encode(url)))
  end
end
