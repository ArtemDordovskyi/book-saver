require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require './app'

require File.expand_path('../app.rb', __FILE__)
use Rack::ShowExceptions
run BookSaver.new
