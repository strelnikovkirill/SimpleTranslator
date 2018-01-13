require_relative 'csv_controller'

RU_EN_FILE = File.expand_path('../../data/RuEnDict.csv', __FILE__).freeze
EN_RU_FILE = File.expand_path('../../data/EnRuDict.csv', __FILE__).freeze

# class responsible for app logic.
class Translator
  attr_accessor :ru, :en

  def initialize
    @ru = CSVController.read_ru_en(RU_EN_FILE)
    @en = CSVController.read_en_ru(EN_RU_FILE)
  end

  def save
    CSVController.write_to_file(RU_EN_FILE, @ru, %w[ru en])
    CSVController.write_to_file(EN_RU_FILE, @en, %w[en ru])
  end

  def formed_str(value)
    value.chomp.strip.downcase.encode('utf-8')
  end

  def search_ru(value)
    value = formed_str(value)
    result = !@ru[value].nil? ? @ru[value] : @en.key(value)
    !result.nil? ? result : 'not found'
  end

  def search_en(value)
    value = formed_str(value)
    result = !@en[value].nil? ? @en[value] : @ru.key(value)
    !result.nil? ? result : 'not found'
  end

  def add_ru(word, translate, flag)
    word = formed_str(word)
    translate = formed_str(translate)
    return unless word != '' && translate != ''
    if !@ru.keys.include? word
      @ru = @ru.merge(word => translate)
    elsif flag == 'on'
      @ru = @ru.merge(word => translate)
    end
  end

  def add_en(word, translate, flag)
    word = formed_str(word)
    translate = formed_str(translate)
    return unless word != '' && translate != ''
    if !@en.keys.include? word
      @en = @en.merge(word => translate)
    elsif flag == 'on'
      @en = @en.merge(word => translate)
    end
  end

  def delete_en(word)
    word = formed_str(word)
    return unless word != ''
    @en.delete_if { |key, _value| key == word }
  end

  def delete_ru(word)
    word = formed_str(word)
    return unless word != ''
    @ru.delete_if { |key, _value| key == word }
  end
end
