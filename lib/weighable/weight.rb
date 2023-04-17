require 'active_support/inflector/methods'

module Weighable
  class Weight
    include Comparable

    attr_reader :value, :unit

    UNIT = {
      gram:        0,
      ounce:       1,
      pound:       2,
      milligram:   3,
      kilogram:    4,
      unit:        5,
      fluid_ounce: 6
    }.freeze

    UNIT_ABBREVIATION = {
      gram:        'g',
      ounce:       'oz',
      pound:       'lb',
      milligram:   'mg',
      kilogram:    'kg',
      fluid_ounce: 'fl oz',
      unit:        nil
    }.freeze

    ABBREVIATION_ALIASES = {
      'g'     => :gram,
      'oz'    => :ounce,
      'lb'    => :pound,
      'mg'    => :milligram,
      'kg'    => :kilogram,
      'fl oz' => :fluid_ounce,
      'ea'    => :unit,
      'each'  => :unit,
      nil     => :unit
    }.freeze

    GRAMS_PER_OUNCE     = BigDecimal('28.34952')
    GRAMS_PER_POUND     = BigDecimal('453.59237')
    OUNCES_PER_POUND    = BigDecimal('16')
    MILLIGRAMS_PER_GRAM = BigDecimal('1000')
    KILOGRAMS_PER_GRAM  = BigDecimal('0.001')
    IDENTITY            = BigDecimal('1')

    MILLIGRAMS_PER_OUNCE    = GRAMS_PER_OUNCE * MILLIGRAMS_PER_GRAM
    KILOGRAMS_PER_OUNCE     = GRAMS_PER_OUNCE * KILOGRAMS_PER_GRAM
    MILLIGRAMS_PER_POUND    = GRAMS_PER_POUND * MILLIGRAMS_PER_GRAM
    KILOGRAMS_PER_POUND     = GRAMS_PER_POUND * KILOGRAMS_PER_GRAM
    MILLIGRAMS_PER_KILOGRAM = MILLIGRAMS_PER_GRAM**2
    FLUID_OUNCE_PER_OUNCE   = IDENTITY

    CONVERSIONS = {
      UNIT[:unit] => {
        UNIT[:unit] => [:*, IDENTITY]
      },
      UNIT[:gram] => {
        UNIT[:gram]        => [:*, IDENTITY],
        UNIT[:ounce]       => [:/, GRAMS_PER_OUNCE],
        UNIT[:pound]       => [:/, GRAMS_PER_POUND],
        UNIT[:milligram]   => [:*, MILLIGRAMS_PER_GRAM],
        UNIT[:kilogram]    => [:*, KILOGRAMS_PER_GRAM],
        UNIT[:fluid_ounce] => [:/, GRAMS_PER_OUNCE]
      },
      UNIT[:ounce] => {
        UNIT[:gram]      => [:*, GRAMS_PER_OUNCE],
        UNIT[:ounce]     => [:*, IDENTITY],
        UNIT[:pound]     => [:/, OUNCES_PER_POUND],
        UNIT[:milligram] => [:*, MILLIGRAMS_PER_OUNCE],
        UNIT[:kilogram]  => [:*, KILOGRAMS_PER_OUNCE],
        UNIT[:fluid_ounce] => [:*, IDENTITY]
      },
      UNIT[:pound] => {
        UNIT[:gram]      => [:*, GRAMS_PER_POUND],
        UNIT[:ounce]     => [:*, OUNCES_PER_POUND],
        UNIT[:pound]     => [:*, IDENTITY],
        UNIT[:milligram] => [:*, MILLIGRAMS_PER_POUND],
        UNIT[:kilogram]  => [:*, KILOGRAMS_PER_POUND],
        UNIT[:fluid_ounce] => [:*, OUNCES_PER_POUND]
      },
      UNIT[:milligram] => {
        UNIT[:gram]      => [:/, MILLIGRAMS_PER_GRAM],
        UNIT[:ounce]     => [:/, MILLIGRAMS_PER_OUNCE],
        UNIT[:pound]     => [:/, MILLIGRAMS_PER_POUND],
        UNIT[:milligram] => [:*, IDENTITY],
        UNIT[:kilogram]  => [:/, MILLIGRAMS_PER_KILOGRAM],
        UNIT[:fluid_ounce] => [:/, MILLIGRAMS_PER_OUNCE]
      },
      UNIT[:kilogram] => {
        UNIT[:gram]      => [:/, KILOGRAMS_PER_GRAM],
        UNIT[:ounce]     => [:/, KILOGRAMS_PER_OUNCE],
        UNIT[:pound]     => [:/, KILOGRAMS_PER_POUND],
        UNIT[:milligram] => [:*, MILLIGRAMS_PER_KILOGRAM],
        UNIT[:kilogram]  => [:*, IDENTITY],
        UNIT[:fluid_ounce] => [:/, KILOGRAMS_PER_OUNCE]
      },
      UNIT[:fluid_ounce] => {
        UNIT[:fluid_ounce] => [:*, IDENTITY],
        UNIT[:gram]        => [:*, GRAMS_PER_OUNCE],
        UNIT[:ounce]       => [:*, IDENTITY],
        UNIT[:pound]       => [:/, OUNCES_PER_POUND],
        UNIT[:milligram]   => [:*, MILLIGRAMS_PER_OUNCE],
        UNIT[:kilogram]    => [:*, KILOGRAMS_PER_OUNCE],
      }
    }.freeze

    def self.parse(string)
      trimmed = string.strip
      unit_start = trimmed.index(' ')
      if unit_start
        unit = trimmed.slice!(unit_start + 1..-1)
        value = trimmed.slice!(0..unit_start - 1)
        from_value_and_unit(value, unit)
      else
        from_value_and_unit(trimmed, nil)
      end
    end

    def self.from_value_and_unit(value, unit)
      unit = parse_unit(unit)
      fail ArgumentError, 'invalid weight' if unit.nil? || value.to_s.strip.empty?
      Weight.new(value, unit)
    end

    def self.parse_unit(unit)
      unit = ActiveSupport::Inflector.singularize(unit.downcase) unless unit.nil?
      unit_symbol = unit ? unit.tr(' ', '_').to_sym : unit
      UNIT[unit_symbol] || ABBREVIATION_ALIASES[unit]
    end

    def initialize(value, unit)
      @value = value.to_d
      @unit = unit
      @unit = unit_from_symbol(unit.to_sym) if unit.respond_to?(:to_sym)
    end

    def to(unit)
      new_unit = unit
      new_unit = unit_from_symbol(unit.to_sym) if unit.respond_to?(:to_sym)
      operator, conversion = conversion(@unit, new_unit)
      new_value = @value.public_send(operator, conversion)
      Weight.new(new_value, unit)
    end

    UNIT.keys.each do |unit|
      unit = unit.to_s
      plural = ActiveSupport::Inflector.pluralize(unit)
      define_method "to_#{unit}" do
        to(unit)
      end
      alias_method "to_#{plural}", "to_#{unit}" unless unit == plural

      define_method "is_#{unit}?" do
        @unit == unit_from_symbol(unit.to_sym)
      end
      alias_method "is_#{plural}?", "is_#{unit}?" unless unit == plural
    end

    def to_s(only_unit: false)
      if only_unit
        unit_abbreviation.to_s
      else
        value = @value.to_f == @value.to_i ? @value.to_i : @value.to_f
        [value, unit_abbreviation].compact.join(' ')
      end
    end

    def +(other)
      other = other.to(unit_name)
      Weight.new(@value + other.value, unit_name)
    end

    def -(other)
      other = other.to(unit_name)
      Weight.new(@value - other.value, unit_name)
    end

    def *(other)
      Weight.new(@value * to_math_value(other), unit_name)
    end

    def /(other)
      if !other.is_a?(Weight) || (other.is_unit? && other.unit != @unit)
        Weight.new(@value / to_math_value(other), unit_name)
      else
        other = other.to(unit_name)
        BigDecimal(@value / other.value)
      end
    end

    def ==(other)
      other.class == self.class && other.value == @value && other.unit == @unit
    end

    def <(other)
      return @value < other if other == 0

      other = other.to(unit_name)
      @value < other.value
    end

    def <=(other)
      return @value <= other if other == 0

      other = other.to(unit_name)
      @value <= other.value
    end

    def >(other)
      return @value > other if other == 0

      other = other.to(unit_name)
      @value > other.value
    end

    def >=(other)
      return @value >= other if other == 0

      other = other.to(unit_name)
      @value >= other.value
    end

    def <=>(other)
      return @value <=> other if other == 0

      other = other.to(unit_name)
      @value <=> other.value
    end

    def round(precision = 0)
      Weight.new(@value.round(precision), @unit)
    end

    def ceil(precision = 0)
      Weight.new(@value.ceil(precision), @unit)
    end

    def floor(precision = 0)
      Weight.new(@value.floor(precision), @unit)
    end

    def abs
      Weight.new(@value.abs, @unit)
    end

    def zero?
      @value.zero?
    end

    private

    def to_math_value(other)
      if other.is_a?(Weight) && other.is_unit?
        other.value
      elsif other.is_a?(Weight)
        other.to(unit_name).value
      else
        other
      end
    end

    def unit_name
      unit_from_int(@unit)
    end

    def unit_abbreviation
      UNIT_ABBREVIATION[unit_from_int(@unit)]
    end

    def unit_from_symbol(unit)
      unit = UNIT[unit]
      fail "invalid unit '#{unit}'" unless unit
      unit
    end

    def unit_from_int(int)
      UNIT.find { |_k, v| v == int }.first
    end

    def conversion(from, to)
      conversion = CONVERSIONS[from][to]
      unless conversion
        fail NoConversionError, "no conversion from #{unit_from_int(from)} to #{unit_from_int(to)}"
      end
      conversion
    end
  end
end
