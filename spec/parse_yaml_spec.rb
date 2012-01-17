require 'helper'
require 'faraday_middleware/response/parse_yaml'

describe FaradayMiddleware::ParseYaml do
  context 'when used' do
    let(:parse_yaml) { described_class.new }

    it 'should load a marshalled hash' do
      me = parse_yaml.on_complete(:body => "--- \nname: Erik Michaels-Ober\n")
      me.class.should == Hash
    end

    it 'should handle hashes' do
      me = parse_yaml.on_complete(:body => "--- \nname: Erik Michaels-Ober\n")
      me['name'].should == 'Erik Michaels-Ober'
    end
  end

  context 'integration test' do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:connection) do
      Faraday::Connection.new do |builder|
        builder.adapter :test, stubs
        builder.use described_class
      end
    end

    it 'should create a Hash from the body' do
      stubs.get('/hash') {[200, {'content-type' => 'application/xml; charset=utf-8'}, "--- \nname: Erik Michaels-Ober\n"]}
      me = connection.get('/hash').body
      me.class.should == Hash
    end
  end
end
