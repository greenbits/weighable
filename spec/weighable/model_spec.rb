require 'spec_helper'
require 'weighable/core_ext'
require 'rails'
require 'active_model'
require 'weighable/model'

class Concerned
  include ActiveModel::Model
  include Weighable::Model

  # these are stubs for what's done via rails migration
  attr_accessor :quantity_value, :quantity_unit, :quantity_display_unit

  weighable :quantity, store_as: :gram, presence: true
end

describe Weighable::Model do
  describe '.weighable' do
    subject(:instance) { Concerned.new }

    it 'adds a setter accepting a hash with symbol keys' do
      instance.quantity = { value: 1, unit: 0 }
      expect(instance.quantity).to eq(Weighable::Weight.new(1, :gram))
    end

    it 'adds a setter accepting a hash with string keys' do
      instance.quantity = { 'value' => 8, 'unit' => 4 }
      expect(instance.quantity).to eq(Weighable::Weight.new(8, :kilogram))
    end

    it 'adds a setter accepting a hash with indifferent access' do
      instance.quantity = { 'value': 33, 'unit': 2 }
      expect(instance.quantity).to eq(Weighable::Weight.new(33, :pound))
    end
  end
end
