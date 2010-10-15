module Kame

  class Table
    attr_reader :name, :model, :options, :id, :columns
    
    @@current_id = 0

    def initialize(name, model, options)
      @name    = name
      @model   = model
      @options = options
      @options[:finder]   ||= :will_paginate_finder
      @options[:renderer] ||= :simple_renderer
      @options[:per_page] = 25 if @options[:per_page].to_i <= 0
      @columns = []
      @current_id = 0
      @id = @@current_id.to_s(36).to_sym
      @@current_id += 1
    end

    def new_id
      id = @current_id.to_s(36).to_sym
      @current_id += 1
      return id
    end

  end

  
  class Column
    attr_accessor :name, :options, :table
    attr_reader :id
    
    def initialize(table, name, options={})
      @table   = table
      @name    = name
      @options = options
      @column  = @table.model.columns_hash[@name.to_s]
      @id = @table.new_id
    end

    def header_code
      raise NotImplementedError.new("#{self.class.name}#header_code is not implemented.")
    end
    
    def sortable?
      false
    end

    # Unique identifier of the column in the application
    def unique_id
      "#{@table.name}-#{@id}"
    end

    # Uncommon but simple identifier for CSS class uses
    def simple_id
      "_#{@table.id}_#{@id}"
    end

  end

end

require "kame/columns/data_column"
require "kame/columns/action_column"
require "kame/columns/field_column"
