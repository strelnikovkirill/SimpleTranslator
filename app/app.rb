require 'sinatra'
require 'sinatra/base'
require_relative 'lib/translator'

# class responsible for web logic.
class AppController < Sinatra::Base
  configure do
    set :root, File.expand_path('../', __FILE__)
    set :translator, Translator.new
  end

  get '/' do
    @en_word = ''
    @ru_word = ''
    @ru_translate = ''
    @en_translate = ''
    erb :index
  end

  post '/translate_en_word' do
    en_value = params['en_value']
    if en_value != ''
      @ru_translate = settings.translator.search_en(en_value)
      @en_word = en_value
    end
    @ru_word = ''
    @en_translate = ''
    erb :index
  end

  post '/translate_ru_word' do
    ru_value = params['ru_value']
    if ru_value != ''
      @en_translate = settings.translator.search_ru(ru_value)
      @ru_word = ru_value
    end
    @en_word = ''
    @ru_translate = ''
    erb :index
  end

  get '/all/:dict' do
    value = params['dict']
    if value == 'ru'
      @result = settings.translator.ru
      erb :all_ru
    elsif value == 'en'
      @result = settings.translator.en
      erb :all_en
    else
      not_found
    end
  end

  post '/add_en_ru' do
    settings.translator.add_en(params['en_word'],
                               params['ru_translate'],
                               params['en_checkbox'])
    settings.translator.save
    redirect to('/all/en')
  end

  post '/add_ru_en' do
    settings.translator.add_ru(params['ru_word'],
                               params['en_translate'],
                               params['ru_checkbox'])
    settings.translator.save
    redirect to('/all/ru')
  end

  post '/delete_ru_en' do
    settings.translator.delete_ru(params['del_word'])
    settings.translator.save
    redirect to('/all/ru')
  end

  post '/delete_en_ru' do
    settings.translator.delete_en(params['del_word'])
    settings.translator.save
    redirect to('/all/en')
  end

  get '/about' do
    erb :about, locals: {
      author_data: 'Kirill Strelnikov',
      year_data: '2018'
    }
  end

  not_found do
    status 404
    'Something gone wrong!'
  end
end
