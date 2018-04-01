require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'

class Aldebaran
  SEARCH = "https://aldebaran.ru/pages/biblio_search/?q="

  def initialize(book_name)
    @book_name = book_name
    @doc = get_doc
  end

  def links
    best_book = @doc.search('.left_block.search_list a').first
    if best_book
      book_page = Nokogiri::HTML(open('https://aldebaran.ru' + best_book['href']))
    else
      book_page = @doc
    end

    links = book_page.search('.b_read a')
    links.reduce({}) do |new, link|
      new.merge!(link.text => link['href'])
    end
  end

  protected
  def get_doc
    url = SEARCH + @book_name
    Nokogiri::HTML(open(URI.encode(url)))
  end
end
