# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Aliquot, type: :model do
  it 'can have a concentration' do
    expect(build(:aliquot, concentration: 0.003).concentration).to eq(0.003)
  end

  it 'can have a fragment size' do
    expect(build(:aliquot, fragment_size: 300).fragment_size).to eq(300)
  end

  it 'can have a qc state' do
    aliquot = build(:aliquot)
    expect(aliquot.qc_state).to be_nil

    aliquot.fail!
    expect(aliquot.qc_state).to eq('fail')

    aliquot.proceed_at_risk!
    expect(aliquot.qc_state).to eq('proceed_at_risk')

    aliquot.proceed!
    expect(aliquot.qc_state).to eq('proceed')
  end

  it 'must have a tube' do
    aliquot = create(:aliquot)
    tube = aliquot.tube
    expect(aliquot.tube).to be_present
    expect(aliquot.tube.barcode).to be_present

    found_aliquot = Aliquot.find(aliquot.id)
    expect(found_aliquot.tube).to eq(tube)
  end

  it 'is not valid without a name' do
    expect(build(:aliquot, name: nil)).to_not be_valid
  end

  it 'can have a source_plate_barcode' do
    aliquot = build(:aliquot, name: 'DN491410A:A1')
    expect(aliquot.source_plate_barcode).to eq('DN491410A')
  end

  it 'can have a source_well_position' do
    aliquot = build(:aliquot, name: 'DN491410A:A1')
    expect(aliquot.source_well_position).to eq('A1')
  end

  it 'can have a short_source_plate_barcode' do
    aliquot = build(:aliquot, name: 'DN491410A:A1')
    expect(aliquot.short_source_plate_barcode).to eq('410A')
  end
end
