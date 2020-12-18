require 'spec_helper'
require 'weighable/core_ext'

module Weighable
  describe Weight do
    it 'should know all of the units' do
      expect(Weight::UNIT).to eq(gram: 0, ounce: 1, pound: 2, milligram: 3, kilogram: 4, unit: 5, fluid_ounce: 6)
    end

    context 'zero?' do
      it 'is if the value is zero' do
        expect(0.units.zero?).to be true
      end

      it 'is not if the value is greater than zero' do
        expect(0.1.grams.zero?).to be false
      end

      it 'is not if the value is less than zero' do
        expect(-0.1.grams.zero?).to be false
      end
    end

    context 'from_value_and_unit' do
      it 'returns the correct weight' do
        expect(Weight.from_value_and_unit(1, 'gram')).to eq(Weight.new(1, :gram))
        expect(Weight.from_value_and_unit(1, 'unit')).to eq(Weight.new(1, :unit))
        expect(Weight.from_value_and_unit(1, 'ea')).to eq(Weight.new(1, :unit))
        expect(Weight.from_value_and_unit(1, 'Ounces')).to eq(Weight.new(1, :ounce))
        expect(Weight.from_value_and_unit(1, 'fl oz')).to eq(Weight.new(1, :fluid_ounce))
      end
    end

    context 'parse' do
      context 'for invalid argument' do
        context 'for an invalid unit' do
          it 'raises an error' do
            expect do
              Weight.parse('1 bob')
            end.to raise_error(ArgumentError, 'invalid weight')
          end
        end

        context 'for a blank string' do
          it 'raises an error' do
            expect do
              Weight.parse(' ')
            end.to raise_error(ArgumentError, 'invalid weight')
          end
        end
      end

      context 'for unit' do
        it 'returns the correct weight with no abbreviation' do
          expect(Weight.parse('1')).to eq(Weight.new(1, :unit))
        end

        it 'returns the correct weight with trailing space' do
          expect(Weight.parse('1 ')).to eq(Weight.new(1, :unit))
        end

        it 'returns the correct unit with leading space' do
          expect(Weight.parse(' 1 ')).to eq(Weight.new(1, :unit))
        end

        it 'returns the correct weight with ea' do
          expect(Weight.parse('1 ea')).to eq(Weight.new(1, :unit))
        end

        it 'returns the correct weight with unit' do
          expect(Weight.parse('1 unit')).to eq(Weight.new(1, :unit))
        end

        it 'returns the correct weight with each' do
          expect(Weight.parse('1 each')).to eq(Weight.new(1, :unit))
        end
      end

      context 'for gram' do
        it 'returns the correct weight' do
          expect(Weight.parse('1.2 g')).to eq(Weight.new(1.2, :gram))
        end

        it 'returns the correct weight with gram' do
          expect(Weight.parse('1.2 Gram')).to eq(Weight.new(1.2, :gram))
        end

        it 'returns the correct weight with grams' do
          expect(Weight.parse('1.2 Grams')).to eq(Weight.new(1.2, :gram))
        end
      end

      context 'for ounce' do
        it 'returns the correct weight' do
          expect(Weight.parse('1 oz')).to eq(Weight.new(1, :ounce))
        end

        it 'returns the correct weight with ounce' do
          expect(Weight.parse('1 ounce')).to eq(Weight.new(1, :ounce))
        end

        it 'returns the correct weight with ounces' do
          expect(Weight.parse('2 ounces')).to eq(Weight.new(2, :ounce))
        end
      end

      context 'for pound' do
        it 'returns the correct weight' do
          expect(Weight.parse('1 lb')).to eq(Weight.new(1, :pound))
        end

        it 'returns the correct weight with pound' do
          expect(Weight.parse('1 pound')).to eq(Weight.new(1, :pound))
        end

        it 'returns the correct weight with pounds' do
          expect(Weight.parse('1 pounds')).to eq(Weight.new(1, :pound))
        end
      end

      context 'for milligram' do
        it 'returns the correct weight' do
          expect(Weight.parse('10.1 mg')).to eq(Weight.new(10.1, :milligram))
        end

        it 'returns the correct weight with milligram' do
          expect(Weight.parse('10.1 milligram')).to eq(Weight.new(10.1, :milligram))
        end

        it 'returns the correct weight with milligrams' do
          expect(Weight.parse('10.1 milligrams')).to eq(Weight.new(10.1, :milligram))
        end
      end

      context 'for kilogram' do
        it 'returns the correct weight' do
          expect(Weight.parse('0.01 kg')).to eq(Weight.new(0.01, :kilogram))
        end

        it 'returns the correct weight for kilogram' do
          expect(Weight.parse('0.01 kilogram')).to eq(Weight.new(0.01, :kilogram))
        end

        it 'returns the correct weight for kilograms' do
          expect(Weight.parse('0.01 kilograms')).to eq(Weight.new(0.01, :kilogram))
        end
      end

      context 'for fluid ounce' do
        it 'returns the correct weight' do
          expect(Weight.parse('1.2 fl oz')).to eq(Weight.new(1.2, :fluid_ounce))
        end

        it 'returns the correct weight with fluid ounce' do
          expect(Weight.parse('1.2 fluid ounce')).to eq(Weight.new(1.2, :fluid_ounce))
        end

        it 'returns the correct weight with fluid ounces' do
          expect(Weight.parse('1.2 fluid ounces')).to eq(Weight.new(1.2, :fluid_ounce))
        end
      end
    end

    context 'to_s' do
      context 'for unit' do
        it 'returns a nice string' do
          expect(Weight.new(1, :unit).to_s).to eq('1')
          expect(Weight.new(1, :unit).to_s(only_unit: true)).to eq('')
        end
      end

      context 'for gram' do
        it 'returns a nice string' do
          expect(Weight.new(1, :gram).to_s).to eq('1 g')
          expect(Weight.new(1, :gram).to_s(only_unit: true)).to eq('g')
        end
      end

      context 'for ounce' do
        it 'returns a nice string' do
          expect(Weight.new(1, :ounce).to_s).to eq('1 oz')
          expect(Weight.new(1, :ounce).to_s(only_unit: true)).to eq('oz')
        end
      end

      context 'for pound' do
        it 'returns a nice string' do
          expect(Weight.new(1, :pound).to_s).to eq('1 lb')
          expect(Weight.new(1, :pound).to_s(only_unit: true)).to eq('lb')
        end
      end

      context 'for milligram' do
        it 'returns a nice string' do
          expect(Weight.new(1, :milligram).to_s).to eq('1 mg')
          expect(Weight.new(1, :milligram).to_s(only_unit: true)).to eq('mg')
        end
      end

      context 'for kilogram' do
        it 'returns a nice string' do
          expect(Weight.new(1, :kilogram).to_s).to eq('1 kg')
          expect(Weight.new(1, :kilogram).to_s(only_unit: true)).to eq('kg')
        end
      end

      context 'for fluid ounce' do
        it 'returns a nice string' do
          expect(Weight.new(1, :fluid_ounce).to_s).to eq('1 fl oz')
          expect(Weight.new(1, :fluid_ounce).to_s(only_unit: true)).to eq('fl oz')
        end
      end
    end

    context 'math' do
      let(:weight_unit) { Weight.new(1, :unit) }
      let(:weight_gram) { Weight.new(1.2, :gram) }
      let(:weight_ounce) { Weight.new(1, :ounce) }

      context 'adding' do
        it 'two like weights' do
          expect(weight_gram + weight_gram).to eq(Weight.new(2.4, :gram))
        end

        it 'two unlike weights' do
          expect(weight_gram + weight_ounce).to eq(Weight.new(BigDecimal('29.54952'), :gram))
        end

        it 'two unlike unit types' do
          expect { weight_unit + weight_gram }.to raise_error(NoConversionError)
          expect { weight_gram + weight_unit }.to raise_error(NoConversionError)
        end
      end

      context 'subtracting' do
        it 'two like weights' do
          expect(weight_gram - weight_gram).to eq(Weight.new(0, :gram))
        end

        it 'two unlike weights' do
          expect(weight_gram - weight_ounce).to eq(Weight.new(BigDecimal('-27.14952'), :gram))
        end

        it 'two unlike unit types' do
          expect { weight_unit - weight_gram }.to raise_error(NoConversionError)
          expect { weight_gram - weight_unit }.to raise_error(NoConversionError)
        end
      end

      context 'multiplying' do
        it 'two like weights' do
          expect(weight_gram * weight_gram).to eq(Weight.new(1.44, :gram))
          expect(weight_unit * weight_unit).to eq(Weight.new(1, :unit))
        end

        it 'two unlike weights' do
          expect(weight_gram * weight_ounce).to eq(Weight.new(BigDecimal('34.019424'), :gram))
        end

        it 'two unlike unit types' do
          expect { weight_unit * weight_gram }.to raise_error(NoConversionError)
        end

        it 'weight-type and unit-type' do
          expect(weight_gram * weight_unit).to eq(Weight.new('1.2', :gram))
        end

        it 'non-weight' do
          expect(weight_gram * 5).to eq(Weight.new(6, :gram))
        end
      end

      context 'dividing' do
        it 'two like weights' do
          expect(weight_gram / weight_gram).to eq(1)
          expect(weight_unit / weight_unit).to eq(1)
        end

        it 'two unlike weights' do
          expect((weight_gram / weight_ounce).round(9)).to eq(BigDecimal('0.042328759'))
        end

        it 'two unlike unit types' do
          expect { weight_unit / weight_gram }.to raise_error(NoConversionError)
        end

        it 'weight-type and unit-type' do
          expect(weight_gram / weight_unit).to eq(Weight.new('1.2', :gram))
        end

        it 'non-weight' do
          expect(weight_gram / 0.2).to eq(Weight.new(6, :gram))
        end
      end
    end

    context 'round' do
      let(:weight) { Weight.new(BigDecimal('60') / BigDecimal('34'), :gram) }

      it 'rounds the value to specified precision' do
        expect(weight.round(8)).to eq(Weight.new(BigDecimal('1.76470588'), :gram))
      end

      it 'should return a copy' do
        weight.round
        expect(weight.value.round(8)).to eq(BigDecimal('1.76470588'))
      end

      it 'rounds the value to default precision' do
        expect(weight.round).to eq(Weight.new(BigDecimal('2'), :gram))
      end
    end

    context 'floor' do
      let(:weight) { Weight.new(BigDecimal('60') / BigDecimal('34'), :gram) }

      it 'floors the value to specified precision' do
        expect(weight.floor(8)).to eq(Weight.new(BigDecimal('1.76470588'), :gram))
      end

      it 'should return a copy' do
        weight.floor
        expect(weight.value.floor(8)).to eq(BigDecimal('1.76470588'))
      end

      it 'floors the value to default precision' do
        expect(weight.floor).to eq(Weight.new(BigDecimal('1'), :gram))
      end
    end

    context 'ceil' do
      let(:weight) { Weight.new(BigDecimal('60') / BigDecimal('34'), :gram) }

      it 'ceils the value to specified precision' do
        expect(weight.ceil(8)).to eq(Weight.new(BigDecimal('1.76470589'), :gram))
      end

      it 'should return a copy' do
        weight.ceil
        expect(weight.value.ceil(8)).to eq(BigDecimal('1.76470589'))
      end

      it 'ceils the value to default precision' do
        expect(weight.ceil).to eq(Weight.new(BigDecimal('2'), :gram))
      end
    end

    context 'abs' do
      let(:weight) { Weight.new(BigDecimal('-20'), :gram) }

      it 'returns absolute value' do
        expect(weight.abs).to eq(Weight.new(BigDecimal('20.0'), :gram))
      end

      it 'should return a copy' do
        weight.abs
        expect(weight.value).to eq(BigDecimal('-20'))
      end

    end

    context 'comparisons' do
      context '<' do
        it 'compares two comparable weights' do
          expect(1.unit < 2.units).to eq(true)
          expect(1.unit < 1.unit).to eq(false)
          expect(2.units < 1.unit).to eq(false)
          expect(1.gram < 1.ounce).to eq(true)
          expect(1.gram < 1.gram).to eq(false)
          expect(1.ounce < 1.gram).to eq(false)
        end

        it 'cannot compare two unlike weights' do
          expect { 1.unit < 1.gram }.to raise_error(Weighable::NoConversionError)
          expect { 1.gram < 1.unit }.to raise_error(Weighable::NoConversionError)
        end
      end

      context '<=' do
        it 'compares two comparable weights' do
          expect(1.unit <= 2.units).to eq(true)
          expect(1.unit <= 1.unit).to eq(true)
          expect(2.units <= 1.unit).to eq(false)
          expect(1.gram <= 1.ounce).to eq(true)
          expect(1.gram <= 1.gram).to eq(true)
          expect(1.ounce <= 1.gram).to eq(false)
        end

        it 'cannot compare two unlike weights' do
          expect { 1.unit <= 1.gram }.to raise_error(Weighable::NoConversionError)
          expect { 1.gram <= 1.unit }.to raise_error(Weighable::NoConversionError)
        end
      end

      context '<=>' do
        it 'compares two comparable weights' do
          expect(1.unit <=> 2.units).to eq(-1)
          expect(1.unit <=> 1.unit).to eq(0)
          expect(2.units <=> 1.unit).to eq(1)
          expect(1.gram <=> 1.ounce).to eq(-1)
          expect(1.gram <=> 1.gram).to eq(0)
          expect(1.ounce <=> 1.gram).to eq(1)
        end

        it 'cannot compare two unlike weights' do
          expect { 1.unit <=> 1.gram }.to raise_error(Weighable::NoConversionError)
          expect { 1.gram <=> 1.unit }.to raise_error(Weighable::NoConversionError)
        end
      end

      context 'comparable' do
        it 'compares two comparable weights' do
          expect(1.unit.between?(0.units, 2.units)).to eq(true)
          expect([1.unit, 2.units, 0.units].sort).to eq([0.units, 1.unit, 2.units])
        end

        it 'cannot compare two unlike weights' do
          expect { 1.unit.between?(1.gram, 2.grams) }.to raise_error(Weighable::NoConversionError)
          expect { 1.gram.between?(1.unit, 2.units) }.to raise_error(Weighable::NoConversionError)
        end
      end

      context '>' do
        it 'compares two comparable weights' do
          expect(2.units > 1.unit).to eq(true)
          expect(1.unit > 1.unit).to eq(false)
          expect(1.unit > 2.units).to eq(false)
          expect(1.gram > 1.ounce).to eq(false)
          expect(1.gram > 1.gram).to eq(false)
          expect(1.ounce > 1.gram).to eq(true)
        end

        it 'cannot compare two unlike weights' do
          expect { 1.unit > 1.gram }.to raise_error(Weighable::NoConversionError)
          expect { 1.gram > 1.unit }.to raise_error(Weighable::NoConversionError)
        end
      end

      context '>=' do
        it 'compares two comparable weights' do
          expect(1.unit >= 2.units).to eq(false)
          expect(1.unit >= 1.unit).to eq(true)
          expect(2.units >= 1.unit).to eq(true)
          expect(1.gram >= 1.ounce).to eq(false)
          expect(1.gram >= 1.gram).to eq(true)
          expect(1.ounce >= 1.gram).to eq(true)
        end

        it 'cannot compare two unlike weights' do
          expect { 1.unit >= 1.gram }.to raise_error(Weighable::NoConversionError)
          expect { 1.gram >= 1.unit }.to raise_error(Weighable::NoConversionError)
        end
      end
    end

    context 'unit checking' do
      context 'for units' do
        let(:weight) { 1.unit }

        it 'should know what unit it is' do
          expect(weight.is_unit?).to eq(true)
          expect(weight.is_units?).to eq(true)
          expect(weight.is_gram?).to eq(false)
          expect(weight.is_grams?).to eq(false)
          expect(weight.is_ounce?).to eq(false)
          expect(weight.is_ounces?).to eq(false)
          expect(weight.is_pound?).to eq(false)
          expect(weight.is_pounds?).to eq(false)
          expect(weight.is_milligram?).to eq(false)
          expect(weight.is_milligrams?).to eq(false)
          expect(weight.is_kilogram?).to eq(false)
          expect(weight.is_kilograms?).to eq(false)
          expect(weight.is_fluid_ounces?).to eq(false)
        end
      end

      context 'for grams' do
        let(:weight) { 1.gram }

        it 'should know what unit it is' do
          expect(weight.is_unit?).to eq(false)
          expect(weight.is_units?).to eq(false)
          expect(weight.is_gram?).to eq(true)
          expect(weight.is_grams?).to eq(true)
          expect(weight.is_ounce?).to eq(false)
          expect(weight.is_ounces?).to eq(false)
          expect(weight.is_pound?).to eq(false)
          expect(weight.is_pounds?).to eq(false)
          expect(weight.is_milligram?).to eq(false)
          expect(weight.is_milligrams?).to eq(false)
          expect(weight.is_kilogram?).to eq(false)
          expect(weight.is_kilograms?).to eq(false)
          expect(weight.is_fluid_ounces?).to eq(false)
        end
      end

      context 'for ounces' do
        let(:weight) { 1.ounce }

        it 'should know what unit it is' do
          expect(weight.is_unit?).to eq(false)
          expect(weight.is_units?).to eq(false)
          expect(weight.is_gram?).to eq(false)
          expect(weight.is_grams?).to eq(false)
          expect(weight.is_ounce?).to eq(true)
          expect(weight.is_ounces?).to eq(true)
          expect(weight.is_pound?).to eq(false)
          expect(weight.is_pounds?).to eq(false)
          expect(weight.is_milligram?).to eq(false)
          expect(weight.is_milligrams?).to eq(false)
          expect(weight.is_kilogram?).to eq(false)
          expect(weight.is_kilograms?).to eq(false)
          expect(weight.is_fluid_ounces?).to eq(false)
        end
      end

      context 'for pounds' do
        let(:weight) { 1.pound }

        it 'should know what unit it is' do
          expect(weight.is_unit?).to eq(false)
          expect(weight.is_units?).to eq(false)
          expect(weight.is_gram?).to eq(false)
          expect(weight.is_grams?).to eq(false)
          expect(weight.is_ounce?).to eq(false)
          expect(weight.is_ounces?).to eq(false)
          expect(weight.is_pound?).to eq(true)
          expect(weight.is_pounds?).to eq(true)
          expect(weight.is_milligram?).to eq(false)
          expect(weight.is_milligrams?).to eq(false)
          expect(weight.is_kilogram?).to eq(false)
          expect(weight.is_kilograms?).to eq(false)
          expect(weight.is_fluid_ounces?).to eq(false)
        end
      end

      context 'for milligrams' do
        let(:weight) { 1.milligram }

        it 'should know what unit it is' do
          expect(weight.is_unit?).to eq(false)
          expect(weight.is_units?).to eq(false)
          expect(weight.is_gram?).to eq(false)
          expect(weight.is_grams?).to eq(false)
          expect(weight.is_ounce?).to eq(false)
          expect(weight.is_ounces?).to eq(false)
          expect(weight.is_pound?).to eq(false)
          expect(weight.is_pounds?).to eq(false)
          expect(weight.is_milligram?).to eq(true)
          expect(weight.is_milligrams?).to eq(true)
          expect(weight.is_kilogram?).to eq(false)
          expect(weight.is_kilograms?).to eq(false)
          expect(weight.is_fluid_ounces?).to eq(false)
        end
      end

      context 'for kilograms' do
        let(:weight) { 1.kilogram }

        it 'should know what unit it is' do
          expect(weight.is_unit?).to eq(false)
          expect(weight.is_units?).to eq(false)
          expect(weight.is_gram?).to eq(false)
          expect(weight.is_grams?).to eq(false)
          expect(weight.is_ounce?).to eq(false)
          expect(weight.is_ounces?).to eq(false)
          expect(weight.is_pound?).to eq(false)
          expect(weight.is_pounds?).to eq(false)
          expect(weight.is_milligram?).to eq(false)
          expect(weight.is_milligrams?).to eq(false)
          expect(weight.is_kilogram?).to eq(true)
          expect(weight.is_kilograms?).to eq(true)
          expect(weight.is_fluid_ounces?).to eq(false)
        end
      end
    end

    context 'from gram' do
      let(:weight) { Weight.new(1, :gram) }

      it 'converts to gram' do
        gram = BigDecimal('1')
        expect(weight.to(:gram)).to eq(Weight.new(gram, :gram))
        expect(weight.to_gram).to eq(Weight.new(gram, :gram))
        expect(weight.to(:gram).value.round(9)).to eq(BigDecimal('1'))
      end

      it 'converts to ounce' do
        ounce = BigDecimal('1') / BigDecimal('28.34952')
        expect(weight.to(:ounce)).to eq(Weight.new(ounce, :ounce))
        expect(weight.to_ounce).to eq(Weight.new(ounce, :ounce))
        expect(weight.to(:ounce).value.round(9)).to eq(BigDecimal('0.035273966'))
      end

      it 'converts to pound' do
        pound = BigDecimal('1') / BigDecimal('453.59237')
        expect(weight.to(:pound)).to eq(Weight.new(pound, :pound))
        expect(weight.to_pound).to eq(Weight.new(pound, :pound))
        expect(weight.to(:pound).value.round(9)).to eq(BigDecimal('0.002204623'))
      end

      it 'converts to milligram' do
        milligram = BigDecimal('1') * BigDecimal('1000')
        expect(weight.to(:milligram)).to eq(Weight.new(milligram, :milligram))
        expect(weight.to_milligram).to eq(Weight.new(milligram, :milligram))
        expect(weight.to(:milligram).value.round(9)).to eq(BigDecimal('1000'))
      end

      it 'converts to kilogram' do
        kilogram = BigDecimal('1') / BigDecimal('1000')
        expect(weight.to(:kilogram)).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to_kilogram).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to(:kilogram).value.round(9)).to eq(BigDecimal('0.001'))
      end

      it 'does not convert to unit' do
        expect { weight.to(:unit) }.to raise_error(NoConversionError)
      end

      it 'converts to fluid ounce' do
        fluid_ounce = BigDecimal('1') / BigDecimal('28.34952')
        expect(weight.to(:fluid_ounce)).to eq(Weight.new(fluid_ounce, :fluid_ounce))
        expect(weight.to_fluid_ounce).to eq(Weight.new(fluid_ounce, :fluid_ounce))
        expect(weight.to(:fluid_ounce).value.round(9)).to eq(BigDecimal('0.035273966'))
      end
    end

    context 'from ounce' do
      let(:weight) { Weight.new(1, :ounce) }

      it 'converts to gram' do
        gram = BigDecimal('1') * BigDecimal('28.34952')
        expect(weight.to(:gram)).to eq(Weight.new(gram, :gram))
        expect(weight.to_gram).to eq(Weight.new(gram, :gram))
        expect(weight.to(:gram).value.round(9)).to eq(BigDecimal('28.34952'))
      end

      it 'converts to ounce' do
        ounce = BigDecimal('1')
        expect(weight.to(:ounce)).to eq(Weight.new(ounce, :ounce))
        expect(weight.to_ounce).to eq(Weight.new(ounce, :ounce))
        expect(weight.to(:ounce).value.round(9)).to eq(BigDecimal('1'))
      end

      it 'converts to pound' do
        pound = BigDecimal('1') / BigDecimal('16')
        expect(weight.to(:pound)).to eq(Weight.new(pound, :pound))
        expect(weight.to_pound).to eq(Weight.new(pound, :pound))
        expect(weight.to(:pound).value.round(9)).to eq(BigDecimal('0.0625'))
      end

      it 'converts to milligram' do
        milligram = BigDecimal('1') * BigDecimal('28349.52')
        expect(weight.to(:milligram)).to eq(Weight.new(milligram, :milligram))
        expect(weight.to_milligram).to eq(Weight.new(milligram, :milligram))
        expect(weight.to(:milligram).value.round(9)).to eq(BigDecimal('28349.52'))
      end

      it 'converts to kilogram' do
        kilogram = BigDecimal('1') * BigDecimal('0.02834952')
        expect(weight.to(:kilogram)).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to_kilogram).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to(:kilogram).value.round(9)).to eq(BigDecimal('0.02834952'))
      end

      it 'does not convert to unit' do
        expect { weight.to(:unit) }.to raise_error(NoConversionError)
      end

      it 'converts to fluid ounce' do
        fluid_ounce = BigDecimal('1')
        expect(weight.to(:fluid_ounce)).to eq(Weight.new(fluid_ounce, :fluid_ounce))
        expect(weight.to_fluid_ounce).to eq(Weight.new(fluid_ounce, :fluid_ounce))
        expect(weight.to(:fluid_ounce).value.round(9)).to eq(BigDecimal('1'))
      end
    end

    context 'from pound' do
      let(:weight) { Weight.new(1, :pound) }

      it 'converts to gram' do
        gram = BigDecimal('1') * BigDecimal('453.59237')
        expect(weight.to(:gram)).to eq(Weight.new(gram, :gram))
        expect(weight.to_gram).to eq(Weight.new(gram, :gram))
        expect(weight.to(:gram).value.round(9)).to eq(BigDecimal('453.59237'))
      end

      it 'converts to ounce' do
        ounce = BigDecimal('1') * BigDecimal('16')
        expect(weight.to(:ounce)).to eq(Weight.new(ounce, :ounce))
        expect(weight.to_ounce).to eq(Weight.new(ounce, :ounce))
        expect(weight.to(:ounce).value.round(9)).to eq(BigDecimal('16'))
      end

      it 'converts to pound' do
        pound = BigDecimal('1')
        expect(weight.to(:pound)).to eq(Weight.new(pound, :pound))
        expect(weight.to_pound).to eq(Weight.new(pound, :pound))
        expect(weight.to(:pound).value.round(9)).to eq(BigDecimal('1'))
      end

      it 'converts to milligram' do
        milligram = BigDecimal('1') * BigDecimal('453592.37')
        expect(weight.to(:milligram)).to eq(Weight.new(milligram, :milligram))
        expect(weight.to_milligram).to eq(Weight.new(milligram, :milligram))
        expect(weight.to(:milligram).value.round(9)).to eq(BigDecimal('453592.37'))
      end

      it 'converts to kilogram' do
        kilogram = BigDecimal('1') * BigDecimal('0.45359237')
        expect(weight.to(:kilogram)).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to_kilogram).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to(:kilogram).value.round(9)).to eq(BigDecimal('0.45359237'))
      end

      it 'does not convert to unit' do
        expect { weight.to(:unit) }.to raise_error(NoConversionError)
      end

      it 'converts to fluid ounce' do
        fluid_ounce = BigDecimal('1') * BigDecimal('16')
        expect(weight.to(:fluid_ounce)).to eq(Weight.new(fluid_ounce, :fluid_ounce))
        expect(weight.to_fluid_ounce).to eq(Weight.new(fluid_ounce, :fluid_ounce))
        expect(weight.to(:fluid_ounce).value.round(9)).to eq(BigDecimal('16'))
      end
    end

    context 'from milligram' do
      let(:weight) { Weight.new(1, :milligram) }

      it 'converts to gram' do
        gram = BigDecimal('1') / BigDecimal('1000')
        expect(weight.to(:gram)).to eq(Weight.new(gram, :gram))
        expect(weight.to_gram).to eq(Weight.new(gram, :gram))
        expect(weight.to(:gram).value.round(9)).to eq(BigDecimal('0.001'))
      end

      it 'converts to ounce' do
        ounce = BigDecimal('1') / BigDecimal('28349.52')
        expect(weight.to(:ounce)).to eq(Weight.new(ounce, :ounce))
        expect(weight.to_ounce).to eq(Weight.new(ounce, :ounce))
        expect(weight.to(:ounce).value.round(9)).to eq(BigDecimal('0.000035274'))
      end

      it 'converts to pound' do
        pound = BigDecimal('1') / BigDecimal('453592.37')
        expect(weight.to(:pound)).to eq(Weight.new(pound, :pound))
        expect(weight.to_pound).to eq(Weight.new(pound, :pound))
        expect(weight.to(:pound).value.round(9)).to eq(BigDecimal('0.000002205'))
      end

      it 'converts to milligram' do
        milligram = BigDecimal('1')
        expect(weight.to(:milligram)).to eq(Weight.new(milligram, :milligram))
        expect(weight.to_milligram).to eq(Weight.new(milligram, :milligram))
        expect(weight.to(:milligram).value.round(9)).to eq(BigDecimal('1'))
      end

      it 'converts to kilogram' do
        kilogram = BigDecimal('1') / BigDecimal('1000000')
        expect(weight.to(:kilogram)).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to_kilogram).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to(:kilogram).value.round(9)).to eq(BigDecimal('0.000001'))
      end

      it 'does not convert to unit' do
        expect { weight.to(:unit) }.to raise_error(NoConversionError)
      end

      it 'converts to fluid ounce' do
        fluid_ounce = BigDecimal('1') / BigDecimal('28349.52')
        expect(weight.to(:fluid_ounce)).to eq(Weight.new(fluid_ounce, :fluid_ounce))
        expect(weight.to_fluid_ounce).to eq(Weight.new(fluid_ounce, :fluid_ounce))
        expect(weight.to(:fluid_ounce).value.round(9)).to eq(BigDecimal('0.000035274'))
      end
    end

    context 'from kilogram' do
      let(:weight) { Weight.new(1, :kilogram) }

      it 'converts to gram' do
        gram = BigDecimal('1') * BigDecimal('1000')
        expect(weight.to(:gram)).to eq(Weight.new(gram, :gram))
        expect(weight.to_gram).to eq(Weight.new(gram, :gram))
        expect(weight.to(:gram).value.round(9)).to eq(BigDecimal('1000'))
      end

      it 'converts to ounce' do
        ounce = BigDecimal('1') / BigDecimal('0.02834952')
        expect(weight.to(:ounce)).to eq(Weight.new(ounce, :ounce))
        expect(weight.to_ounce).to eq(Weight.new(ounce, :ounce))
        expect(weight.to(:ounce).value.round(9)).to eq(BigDecimal('35.273965838'))
      end

      it 'converts to pound' do
        pound = BigDecimal('1') / BigDecimal('0.45359237')
        expect(weight.to(:pound)).to eq(Weight.new(pound, :pound))
        expect(weight.to_pound).to eq(Weight.new(pound, :pound))
        expect(weight.to(:pound).value.round(9)).to eq(BigDecimal('2.204622622'))
      end

      it 'converts to milligram' do
        milligram = BigDecimal('1') * BigDecimal('1000000')
        expect(weight.to(:milligram)).to eq(Weight.new(milligram, :milligram))
        expect(weight.to_milligram).to eq(Weight.new(milligram, :milligram))
        expect(weight.to(:milligram).value.round(9)).to eq(BigDecimal('1000000'))
      end

      it 'converts to kilogram' do
        kilogram = BigDecimal('1')
        expect(weight.to(:kilogram)).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to_kilogram).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to(:kilogram).value.round(9)).to eq(BigDecimal('1'))
      end

      it 'does not convert to unit' do
        expect { weight.to(:unit) }.to raise_error(NoConversionError)
      end

      it 'converts to fluid ounce' do
        fluid_ounce = BigDecimal('1') / BigDecimal('0.02834952')
        expect(weight.to(:fluid_ounce)).to eq(Weight.new(fluid_ounce, :fluid_ounce))
        expect(weight.to_fluid_ounce).to eq(Weight.new(fluid_ounce, :fluid_ounce))
        expect(weight.to(:fluid_ounce).value.round(9)).to eq(BigDecimal('35.273965838'))
      end
    end

    context 'from unit' do
      let(:weight) { Weight.new(1, :unit) }

      it 'does not convert to gram' do
        expect { weight.to(:gram) }.to raise_error(NoConversionError)
      end

      it 'does not convert to ounce' do
        expect { weight.to(:ounce) }.to raise_error(NoConversionError)
      end

      it 'does not convert to pound' do
        expect { weight.to(:pound) }.to raise_error(NoConversionError)
      end

      it 'does not convert to milligram' do
        expect { weight.to(:milligram) }.to raise_error(NoConversionError)
      end

      it 'does not convert to kilogram' do
        expect { weight.to(:kilogram) }.to raise_error(NoConversionError)
      end

      it 'does not convert to fluid ounce' do
        expect { weight.to(:fluid_ounce)}.to raise_error(NoConversionError)
      end

      it 'converts to unit' do
        unit = BigDecimal('1')
        expect(weight.to(:unit)).to eq(Weight.new(unit, :unit))
        expect(weight.to_unit).to eq(Weight.new(unit, :unit))
        expect(weight.to(:unit).value.round(9)).to eq(BigDecimal('1'))
      end
    end

    context 'from fluid ounce' do
      let(:weight) { Weight.new(1, :fluid_ounce) }

      it 'converts to gram' do
        gram = BigDecimal('1') * BigDecimal('28.34952')
        expect(weight.to(:gram)).to eq(Weight.new(gram, :gram))
        expect(weight.to_gram).to eq(Weight.new(gram, :gram))
        expect(weight.to(:gram).value.round(9)).to eq(BigDecimal('28.34952'))
      end

      it 'converts to ounce with identity' do
        unit = BigDecimal('1')
        expect(weight.to(:ounce)).to eq(Weight.new(unit, :ounce))
        expect(weight.to_ounce).to eq(Weight.new(unit, :ounce))
        expect(weight.to(:ounce).value.round(9)).to eq(BigDecimal('1'))
      end

      it 'converts to pound' do
        pound = BigDecimal('1') / BigDecimal('16')
        expect(weight.to(:pound)).to eq(Weight.new(pound, :pound))
        expect(weight.to_pound).to eq(Weight.new(pound, :pound))
        expect(weight.to(:pound).value.round(9)).to eq(BigDecimal('0.0625'))
      end

      it 'converts to milligram' do
        milligram = BigDecimal('1') * BigDecimal('28349.52')
        expect(weight.to(:milligram)).to eq(Weight.new(milligram, :milligram))
        expect(weight.to_milligram).to eq(Weight.new(milligram, :milligram))
        expect(weight.to(:milligram).value.round(9)).to eq(BigDecimal('28349.52'))
      end

      it 'converts to kilogram' do
        kilogram = BigDecimal('1') * BigDecimal('0.02834952')
        expect(weight.to(:kilogram)).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to_kilogram).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to(:kilogram).value.round(9)).to eq(BigDecimal('0.02834952'))
      end

      it 'does not convert to unit' do
        expect { weight.to(:unit)}.to raise_error(NoConversionError)
      end

      it 'converts to fluid ounce' do
        unit = BigDecimal('1')
        expect(weight.to(:fluid_ounce)).to eq(Weight.new(unit, :fluid_ounce))
        expect(weight.to_fluid_ounce).to eq(Weight.new(unit, :fluid_ounce))
        expect(weight.to(:fluid_ounce).value.round(9)).to eq(BigDecimal('1'))
      end
    end
  end
end
