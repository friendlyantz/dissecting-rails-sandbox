# frozen_string_literal: true

require 'active_support'
require 'ostruct'
require_relative 'extensions'

class App
  include Extentions
  def initialize
    self.class
        .instance_methods(false)
        .each { |method| send method }

    puts '='.blue * 50
    Extentions.instance_methods
              .each { |method| send method }
  end

  def hash_with_indifferent_access
    puts 'Hash with indifferent access'.red
    require 'active_support/core_ext/hash/indifferent_access'
    hash = { a: 'hash_key' }.with_indifferent_access
    puts hash['a']
    puts hash[:a]

    try = { a: 'key not founfd' }['a'] # => 1w
    puts try
    try_2 = { a: 'value' }[:a] # => 1w
    puts try_2
    result = { a: 'another value' }.with_indifferent_access['a']
    puts result
  end

  def blank_check
    require 'active_support/core_ext'
    puts 'Blank check'.red
    puts ['', ' ', nil, [], {}].map(&:blank?)
  end

  def presence_check
    puts 'Presence check'.red
    os = ::OpenStruct.new(a: '')
    puts os.a || 'default not returned as key is found but value is empty string'
    require 'active_support/core_ext'
    puts os.a.presence || 'default replacing empty string'
  end

  def duplicable_check
    puts 'Duplicable check'.red
    require 'active_support/core_ext'
    puts({ a: 'hash' }.duplicable?)
    puts 1.method(:+).duplicable?
  end

  def deep_dup_check
    puts 'Deep dup check'.red
    puts 'not deep'.light_red
    array = ['string']
    duplicate = array.dup

    # frozen string is not disabled
    duplicate.first.gsub!('string', 'foo')

    puts array     # => ['string']
    puts duplicate # => ['foo']

    puts 'deep'.light_red
    array = ['string']
    duplicate = array.deep_dup

    duplicate.first.gsub!('string', 'foo')

    puts array     # => ['string']
    puts duplicate # => ['foo']
  end

  def try_check
    puts 'Try check'.red
    require 'active_support/core_ext'
    puts nil.try(:to_s)
    puts 1.try(:to_s)
    puts(1.try { |i| i + 99 })
  end

  def acts_like_check
    puts 'Acts like check'.red
    require 'active_support/core_ext'
    duck = ::OpenStruct.new
    duck.define_singleton_method(:acts_like_duck?) do
      puts 'Quack!'
    end
    puts duck.acts_like?(:duck)
  end

  def to_param_check
    puts 'To param check'.red
    require 'active_support/core_ext'
    puts [:hey, true, 'babe', false, 777, nil, 22.2].to_param
  end

  def to_query_check
    puts 'To query check'.red
    require 'active_support/core_ext'
    q = { a: 1, b: 2 }.to_query
    puts q.to_s.green
    q = { :a => 1, 'b' => 2 }.to_query('boobs')
    puts q.to_s.green
  end

  def with_options_check
    puts 'With options check'.red
    require 'active_support/core_ext'
    ::OpenStruct.with_options lala: :dida do |o|
      puts o.new.to_s.yellow
    end
  end

  def instance_method_check
    puts 'Instance method check'.red
    require 'active_support/core_ext'
    duck = ::OpenStruct.new(a: 1, b: 2)
    duck.instance_variable_set(:@greening_sound, 'Quack!')
    puts duck.instance_values
  end

  def in_check_and_supress
    puts 'In check'.red
    puts 1.in?([1, 2]) # => true
    puts 'lo'.in?('hello')   # => true
    puts 25.in?(30..50)      # => false
    suppress(ArgumentError) do
      puts 1.in?(1) # => ArgumentError
    end
  end
end
