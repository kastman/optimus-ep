# Part of the Optimus package for managing E-Prime data
# 
# Copyright (C) 2008-09 Board of Regents of the University of Wisconsin System
# 
# Written by Nathan Vack <njvack@wisc.edu>, at the Waisman Laborotory for Brain
# Imaging and Behavior, University of Wisconsin - Madison


module Optimus
  class Reader
    
    # This class is for reading tab-delimited Optimus files. (Or, really, any tab-delimited file).
    # The main option of interest is the :skip_lines option, which specifies how many lines
    # to skip before finding column names. For example:
    #
    # TabfileParser.new(stream, :skip_lines => 1)
    #
    # is what you'd use for skipping the filename line in a standard optimus Excel file.
    #
    # Note: you'll generally be using subclasses of this, and not manually specifying skip_lines.
    
    class TabfileParser
      def initialize(file, options = {})
        @file = file
        @skip_lines = options[:skip_lines] || 0
        @columns = options[:columns]
        @merge_header_lines = options[:merge_header_lines] || 1
      end
      
      def to_optimus
        lines = @file.read
        lines.gsub!(/\r\n?/,"\n")
        lines = lines.split("\n")
        
        raise DamagedFileError.new("File #{@file.path} appears to be empty.") if lines.nil?
        
        @skip_lines.times do
          lines.shift
        end
        
        headers = []

        @merge_header_lines.times do
          l = lines.shift
          headers << l.split("\t",-1).map {|elt| elt.strip }
        end
        file_columns = headers[0].zip(*headers[1..-1]).map{|labels| labels.join(' ')}

        expected_size = file_columns.size
        columns = file_columns
        data = Optimus::Data.new(columns)
        current_line = @skip_lines+1
        lines.each do |line|
          current_line += 1
          row = data.add_row
          col_data = line.split("\t",-1).map {|e| e.strip }
          if col_data.size != expected_size
            raise DamagedFileError.new("In #{@file.path}, line #{current_line} should have #{expected_size} columns but had #{col_data.size}.")
          end
          row.values = col_data
        end
        return data
      end
    end
  end 
end