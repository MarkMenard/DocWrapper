require File.expand_path("../../lib/doc_wrapper", __FILE__)
require 'nokogiri'

def read_fixture_file (file_name)
  File.open(File.join(File.dirname(__FILE__), "/fixtures/#{file_name}")).read
end
