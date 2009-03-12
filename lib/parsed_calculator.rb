# Part of the Optimus package for managing E-Prime data
# 
# Copyright (C) 2008 Board of Regents of the University of Wisconsin System
# 
# Written by Nathan Vack <njvack@wisc.edu>, at the Waisman Laborotory for Brain
# Imaging and Behavior, University of Wisconsin - Madison
#
# A two-stage parser that should be both faster and more flexible than the
# one-stage regex hack currently in use.
# Major difference: this will return parse trees that need to be evaluated
# by passing in a row's worth of data, instead of directly evaluating a string
# after substituting row data.

require 'rubygems'
require 'rparsec'
require 'pp'

module Eprime
  module ParsedCalculator
    include RParsec
    class ExpressionParser
      extend RParsec::Parsers
      include RParsec::Parsers

      def initialize
        lit = (
          token(:str) { |lex| StringLiteral.new(lex) } |
          token(:number) { |lex| NumberLiteral.new(lex) } |
          token(:column) { |lex| ColumnReference.new(lex) } )
        table = RParsec::OperatorTable.new
        expr = RParsec::Expressions.build(lit, table)
        
        lexeme = tokenizer.lexeme(whitespaces) << eof
        @parser = lexeme.nested(expr << eof)
      end
      
      def parse(str)
        @parser.parse(str)
      end
      
      private
      
      def tokenizer
        return (
          string_literal.token(:str) |
          number.token(:number) |
          column_reference.token(:column)
        )
      end
      
      def string_literal
        (char("'") >> (not_char("'")|str("''")).many.fragment << char("'"))
      end
      
      def column_reference
        (char('{') >> (string('\}')|not_char('}')).many_.fragment << char('}'))
      end
    end
    
    class NumberLiteral
      def initialize(token)
        @token = token
      end
      
      def to_s
        @token
      end
    end
    
    class StringLiteral
      def initialize(token)
        @token = token
      end
      
      def to_s
        "'#{@token}'"
      end
    end
    
    class ColumnReference
      def initialize(name)
        @name = name
      end
      
      def to_s
        "{#{@name}}"
      end
    end
    
  end
end