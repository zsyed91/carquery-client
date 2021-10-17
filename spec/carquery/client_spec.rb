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

  describe 'models_for_year_and_make' do
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
end
