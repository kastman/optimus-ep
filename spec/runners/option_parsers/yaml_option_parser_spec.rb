# Part of the Optimus package for managing E-Prime data
# 
# Copyright (C) 2008-09 Board of Regents of the University of Wisconsin System
# 
# Written by Nathan Vack <njvack@wisc.edu>, at the Waisman Laborotory for Brain
# Imaging and Behavior, University of Wisconsin - Madison
# 
# This execrises the main command-line runner system.

require File.join(File.dirname(__FILE__),'../../spec_helper')
require File.join(File.dirname(__FILE__), '../../../lib/optimus')
include OptimusTestHelper

require 'runners/option_parsers/yaml_option_parser'
include Optimus::Runners::OptionParsers

describe YamlOptionParser do
  before :each do
    @op = YamlOptionParser.new
  end
  
  it "should have errors" do
    @op.errors.should_not be_nil
  end
end