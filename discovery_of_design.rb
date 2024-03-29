require 'sinatra'
require 'yaml'

class DiscoveryOfDesign < Sinatra::Base
  before do
    return unless Sinatra::Base.production?
    redirect request.url.sub('http', 'https') unless request.secure?
  end

  get '/' do
    haml :index
  end

  get '/new_book' do
    haml :new_book
  end

  get '/design_of_the_month' do
    haml :'design_examples/underwater/octopus_water_leaks', locals: { title: 'Octopus - Water Leaks' }
  end

  get '/background' do
    haml :background
  end

  get '/useful_links' do
    haml :useful_links
  end

  get '/books_by_deyoung' do
    haml :books_by_deyoung
  end

  get '/book_of_the_month' do
    haml :our_created_moon_book
  end

  get '/about_deyoung' do
    haml :about_deyoung
  end

  get '/contact_us' do
    haml :contact_us
  end

  categories = {
    microorganisms:     'Microorganisms',
    flight:             'Flight',
    land_animals:       'Land Animals',
    nonliving_objects:  'Non-living Objects',
    people:             'People',
    small_creatures:    'Small Creatures',
    underwater:         'Underwater',
    vegetation:         'Vegetation'
  }

  categories.each do |category, title|
    file = YAML.load_file("etc/#{category}.yml")

    get "/#{category}" do
      haml :'design_examples/index', locals: { examples: file, title: title }
    end

    file.each do |name, attrs|
      get "/#{attrs['url']}" do
        haml "design_examples/#{category}/#{attrs['url']}".to_sym, locals: { title: name }
      end
    end
  end
end
