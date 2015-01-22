# Author: Mark Menard
# Copyright Enable Labs 2009
# Usage governed under terms of the Enable Labs Master Service Agreement.

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'active_support'
require 'active_support/core_ext/object/blank'
require 'doc_wrapper/sattr_accessor'
require 'doc_wrapper/properties'
require 'doc_wrapper/base_class_methods'
require 'doc_wrapper/base'
require 'doc_wrapper/multi_property_definition'
require 'doc_wrapper/base_property_definition'
require 'doc_wrapper/raw_property_definition'
require 'doc_wrapper/has_many_property_definition'
require 'doc_wrapper/has_one_property_definition'
require 'doc_wrapper/inner_html_property_definition'
require 'doc_wrapper/string_property_definition'
require 'doc_wrapper/date_property_definition'
require 'doc_wrapper/time_property_definition'
require 'doc_wrapper/boolean_property_definition'
require 'doc_wrapper/float_property_definition'
