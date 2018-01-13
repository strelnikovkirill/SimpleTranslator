require 'test_helper'
require_relative '../app/lib/translator'

describe Translator do
  before do
    @en_ru = { 'a' => 'b' }
    @ru_en = { 'c' => 'd' }
    CSVController.expects(:read_en_ru)
                 .with(EN_RU_FILE)
                 .returns(@en_ru)
    CSVController.expects(:read_ru_en)
                 .with(RU_EN_FILE)
                 .returns(@ru_en)
    @translator = Translator.new
  end

  describe '#initialize' do
    it 'should return initialized Translator obj' do
      _(@translator.en).must_equal @en_ru
      _(@translator.ru).must_equal @ru_en
    end
  end

  describe '#save' do
    it 'should nil if hashes are saved to files' do
      CSVController.expects(:write_to_file)
                   .with(EN_RU_FILE, @en_ru, %w[en ru])
                   .returns(nil)
      CSVController.expects(:write_to_file)
                   .with(RU_EN_FILE, @ru_en, %w[ru en])
                   .returns(nil)
      _(@translator.save).must_equal nil
    end
  end

  describe '#formed_str' do
    it 'should return formed string' do
      value = ' TeST  '
      result = 'test'
      _(@translator.formed_str(value)).must_equal result
    end
  end

  describe '#search_ru' do
    it 'should return value by key in ru-en hash' do
      value = 'c'
      result = @ru_en[value]
      _(@translator.search_ru(value)).must_equal result
    end
  end

  describe '#search_en' do
    it 'should return value by key in en-ru hash' do
      value = 'a'
      result = @en_ru[value]
      _(@translator.search_en(value)).must_equal result
    end
  end

  describe '#add_ru' do
    it 'should return ru-en hash if new word added' do
      word = 'd'
      translate = 'e'
      flag = nil
      @ru_en = @ru_en.merge(word => translate)
      _(@translator.add_ru(word, translate, flag)).must_equal @ru_en
    end
    it 'should return ru-en hash if word updated' do
      word = 'c'
      translate = 'e'
      flag = 'on'
      @ru_en = @ru_en.merge(word => translate)
      _(@translator.add_ru(word, translate, flag)).must_equal @ru_en
    end
  end

  describe '#add_en' do
    it 'should return ru-en hash if new word added' do
      word = 'f'
      translate = 'e'
      flag = nil
      @en_ru = @en_ru.merge(word => translate)
      _(@translator.add_en(word, translate, flag)).must_equal @en_ru
    end
    it 'should return ru-en hash if new word updated' do
      word = 'a'
      translate = 'e'
      flag = 'on'
      @en_ru = @en_ru.merge(word => translate)
      _(@translator.add_en(word, translate, flag)).must_equal @en_ru
    end
  end

  describe '#delete_en' do
    it 'should return en-ru hash if word deleted' do
      word = 'a'
      @en_ru.delete_if { |key, _value| key == word }
      _(@translator.delete_en(word)).must_equal @en_ru
    end
  end

  describe '#delete_ru' do
    it 'should return ru-en hash if word deleted' do
      word = 'c'
      @ru_en.delete_if { |key, _value| key == word }
      _(@translator.delete_ru(word)).must_equal @ru_en
    end
  end
end
