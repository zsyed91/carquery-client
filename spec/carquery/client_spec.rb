require 'ostruct'
require 'json'

RSpec.describe Carquery::Client do
  subject(:client) { described_class.new }
  let(:connection) { instance_double('Faraday::Connection') }
  let(:year) { '2016' }

  let(:years_range) { { "min_year"=>"1941", "max_year"=>"2021" } }
  let(:years_response) do
    OpenStruct.new(body: { "Years" => years_range })
  end

  let(:make) do
    {
      "make_id"=>"nissan",
      "make_display"=>"Nissan",
      "make_is_common" => "1"
    }
  end
  let(:makes_response) { OpenStruct.new(body: { "Makes" => [make] }) }

  let(:model) do
    { "model_name" => "370Z", "model_make_id" => "Nissan" }
  end
  let(:models_response) do
    OpenStruct.new(body: { 'Models' => [model] })
  end

  let(:trim) do
     {
      'model_id' => '67598',
      'model_make_id' => 'Nissan',
      'model_name' => '370Z',
      'model_trim' => '2dr Convertible (3.7L 6cyl 7A)',
      'model_year' => '2016',
      'model_body' => 'Two Seaters',
      'model_engine_position' => 'Front',
      'model_engine_cc' => '3700',
      'model_engine_cyl' => '6',
      'model_engine_type' => 'V',
      'model_engine_valves_per_cyl' => '4',
      'model_engine_power_ps' => '332',
      'model_engine_power_rpm' => nil,
      'model_engine_torque_nm' => '270',
      'model_engine_torque_rpm' => nil,
      'model_engine_bore_mm' => nil,
      'model_engine_stroke_mm' => nil,
      'model_engine_compression' => '11',
      'model_engine_fuel' => 'Premium Unleaded (Required)',
      'model_top_speed_kph' => nil,
      'model_0_to_100_kph' => nil,
      'model_drive' => 'Rear Wheel Drive',
      'model_transmission_type' => 'Automatic',
      'model_seats' => nil,
      'model_doors' => '2',
      'model_weight_kg' => '3470',
      'model_length_mm' => nil,
      'model_width_mm' => nil,
      'model_height_mm' => nil,
      'model_wheelbase_mm' => nil,
      'model_lkm_hwy' => '25.0',
      'model_lkm_mixed' => '21.0',
      'model_lkm_city' => '18.0',
      'model_fuel_cap_l' => '19',
      'model_sold_in_us' => '1',
      'model_co2' => nil,
      'model_make_display' => 'Nissan',
      'make_display' => 'Nissan',
      'make_country' => 'Japan'
    }
  end
  let(:trims_response) do
    OpenStruct.new(body: { 'Trims' => [trim] })
  end

  before do
    allow(Faraday::Connection).to receive(:new).and_return(connection)
  end

  describe '#years' do
    before do
      allow(connection).to receive(:get).and_return(years_response)
    end

    it 'calls the correct API' do
      expect(connection).to receive(:get).with(kind_of(String), cmd: 'getYears')
      client.years
    end

    it 'returns the years' do
      response = client.years
      expect(response).to eq(years_range)
    end
  end

  describe '#makes_for_year' do
    before do
      allow(connection).to receive(:get).and_return(makes_response)
    end

    it 'calls the correct API' do
      expect(connection).to(
        receive(:get)
          .with(
            kind_of(String), cmd: 'getMakes', year: year, sold_in_us: 1
          )
      )

      client.makes_for_year(year)
    end

    it 'returns the makes' do
      response = client.makes_for_year(year)
      expect(response).to eq([make])
    end
  end

  describe '#models_for_year_and_make' do
    before do
      allow(connection).to receive(:get).and_return(models_response)
    end

    it 'calls the correct API' do
      expect(connection).to(
        receive(:get)
          .with(
            kind_of(String),
            cmd: 'getModels',
            year: year,
            make: make['make_id'],
            sold_in_us: 1
          )
      )

      client.models_for_year_and_make(year, make['make_id'])
    end

    it 'returns the models' do
      response = client.models_for_year_and_make(year, make['make_id'])
      expect(response).to eq([model])
    end
  end

  describe '#trims_for_model' do
    before do
      allow(connection).to receive(:get).and_return(trims_response)
    end

    it 'calls the correct API' do
      expect(connection).to(
        receive(:get)
          .with(
            kind_of(String),
            cmd: 'getTrims',
            year: year,
            make: make['make_id'],
            model: model['model_name'],
        )
      )

      client.trims_for_model(year, make['make_id'], model['model_name'])
    end

    it 'returns the trims' do
      response = client.trims_for_model(year, make['make_id'], model['model_name'])
      expect(response).to eq([trim])
    end
  end
end
