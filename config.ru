require 'rubygems'

require "./api"

use Rack::PostBodyContentTypeParser
run App