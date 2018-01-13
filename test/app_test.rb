require 'test_helper'

# class describe app test cases
class AppTestCase < CapybaraTestCase
  def setup
    Capybara.app = Rack::Builder.parse_file(File.expand_path('../../app/config.ru', __FILE__)).first
  end

  def test_should_contain_index_view
    visit('/')
    assert_text 'MAIN PAGE'
  end

  def test_should_contain_all_ru_view
    visit('/all/ru')
    assert_text 'ALL RU-EN WORDS'
  end

  def test_should_contain_all_en_view
    visit('/all/en')
    assert_text 'ALL EN-RU WORDS'
  end

  def test_should_contain_all_not_found_view
    visit('/all/error')
    assert_text 'Something gone wrong!'
  end

  def test_should_contain_about_view
    visit('/about')
    assert_text 'ABOUT'
  end

  def test_should_contain_not_found_view
    visit('/some_error_route')
    assert_text 'Something gone wrong!'
  end

  def test_should_translate_en_word
    visit('/')
    fill_in('en_value', with: 'some_en_word')
    click_on('TRANSLATE (EN->RU)')
    assert_text 'some_ru_word'
  end

  def test_should_translate_ru_word
    visit('/')
    fill_in('ru_value', with: 'some_ru_word')
    click_on('TRANSLATE (RU->EN)')
    assert_text 'some_en_word'
  end

  def test_should_add_en_ru_words
    visit('/all/en')
    fill_in('en_word', with: 'some_en_word')
    fill_in('ru_translate', with: 'some_ru_word')
    click_on('ADD (EN->RU)')
    assert_text 'some_en_word some_ru_word'
  end

  def test_should_add_ru_en_words
    visit('/all/ru')
    fill_in('ru_word', with: 'some_ru_word')
    fill_in('en_translate', with: 'some_en_word')
    click_on('ADD (RU->EN)')
    assert_text 'some_ru_word some_en_word'
  end

  def test_should_delete_ru_en_words
    visit('/all/ru')
    fill_in('del_word', with: 'some_ru_word')
    click_on('DELETE (RU->EN)')
    assert_no_text 'some_ru_word some_en_word'
  end

  def test_should_delete_en_ru_words
    visit('/all/en')
    fill_in('del_word', with: 'some_en_word')
    click_on('DELETE (EN->RU)')
    assert_no_text 'some_en_word some_ru_word'
  end
end
