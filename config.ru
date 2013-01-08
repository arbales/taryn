# $:.unshift File.expand_path("../", __FILE__)
require 'bundler'
Bundler.require

require 'sinatra'
require 'haml'
require 'sprockets'
require 'sprockets-sass'
require 'sprockets-helpers'
# require 'sprockets-commonjs'
require 'sass'
require 'compass'

require 'uglifier'
require "yui/compressor"

require "./application"

map '/assets' do
  environment = Sprockets::Environment.new

  Application.set :sprockets, environment
  Application.set :assets_prefix, "/assets"
  Application.set :digest_assets, true

  environment.append_path 'assets/samples'
  environment.append_path 'assets/javascripts'
  environment.append_path 'assets/stylesheets'
  environment.append_path 'assets/images'
  environment.append_path 'vendor/assets/javascripts'


  Sprockets::Helpers.configure do |config|
    config.environment  = environment
    config.prefix       = "/assets"
    config.digest       = true
  end

  # environment.js_compressor = Uglifier.new(:copyright => false)
  # environment.css_compressor = YUI::CssCompressor.new
  Application.helpers Sprockets::Helpers
  #
  # Application.helpers Sinatra::Sprockets::Helpers
  run environment
end

module Sass::Script::Functions
  def random(min = Sass::Script::Number.new(0), max = Sass::Script::Number.new(100))
    Sass::Script::Number.new(rand(min.value..max.value), max.numerator_units, max.denominator_units)
  end
end

map '/' do
  run Application
end

