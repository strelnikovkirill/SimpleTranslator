require 'test_helper'
require 'csv'
require_relative '../app/lib/translator'

describe CSVController do
  describe '.read_en_ru' do
    it 'should return an hash of en-ru dictionary' do
      CSV.expects(:foreach)
         .with(EN_RU_FILE, headers: true, skip_blanks: true)
         .multiple_yields([CSV::Row.new(%w[en ru], %w[a b])])
      result = { 'a' => 'b' }
      _(CSVController.read_en_ru(EN_RU_FILE)).must_equal result
    end
  end

  describe '.read_ru_en' do
    it 'should return an hash of ru-en dictionary' do
      CSV.expects(:foreach)
         .with(RU_EN_FILE, headers: true, skip_blanks: true)
         .multiple_yields([CSV::Row.new(%w[ru en], %w[b a])])
      result = { 'b' => 'a' }
      _(CSVController.read_ru_en(RU_EN_FILE)).must_equal result
    end
  end

  describe '.write_to_file' do
    it 'should return nil if strings were append in file' do
      headers = %w[ru en]
      CSV.expects(:open)
         .with(RU_EN_FILE, 'w')
         .multiple_yields([CSV::Row.new(headers, %w[a b])])
      _(CSVController.write_to_file(RU_EN_FILE,
                                    { 'a' => 'b' },
                                    headers)).must_equal nil
    end
  end
end
