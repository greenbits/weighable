require 'spec_helper'
require 'weighable/core_ext/string'

describe String do
  it 'creates helper methods for all units' do
    expect('2.33'.units).to eq(Weighable::Weight.new(BigDecimal('2.33'), :unit))
    expect('2.33'.unit).to eq(Weighable::Weight.new(BigDecimal('2.33'), :unit))
    expect('2.33'.grams).to eq(Weighable::Weight.new(BigDecimal('2.33'), :gram))
    expect('2.33'.gram).to eq(Weighable::Weight.new(BigDecimal('2.33'), :gram))
    expect('2.33'.ounces).to eq(Weighable::Weight.new(BigDecimal('2.33'), :ounce))
    expect('2.33'.ounce).to eq(Weighable::Weight.new(BigDecimal('2.33'), :ounce))
    expect('2.33'.pounds).to eq(Weighable::Weight.new(BigDecimal('2.33'), :pound))
    expect('2.33'.pound).to eq(Weighable::Weight.new(BigDecimal('2.33'), :pound))
    expect('2.33'.milligrams).to eq(Weighable::Weight.new(BigDecimal('2.33'), :milligram))
    expect('2.33'.milligram).to eq(Weighable::Weight.new(BigDecimal('2.33'), :milligram))
    expect('2.33'.kilograms).to eq(Weighable::Weight.new(BigDecimal('2.33'), :kilogram))
    expect('2.33'.kilogram).to eq(Weighable::Weight.new(BigDecimal('2.33'), :kilogram))
    expect('2.33'.fluid_ounces).to eq(Weighable::Weight.new(BigDecimal('2.33'), :fluid_ounce))
    expect('2.33'.fluid_ounce).to eq(Weighable::Weight.new(BigDecimal('2.33'), :fluid_ounce))
  end
end
