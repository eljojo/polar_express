require "polar_express/version"
require "polar_express/polar_express"
require "polar_express/tracker"
require "polar_express/dhl"
require "polar_express/gls"
require "polar_express/hermes"
require "polar_express/shipping_info"

module PolarExpress
  # I don't really know if doing the requires in here helps to keep them under this scope.
  require 'open-uri'
  require 'nokogiri'
  require 'date'
  require 'json'
  require 'net/http'
end
