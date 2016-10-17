require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'pry'
require 'securerandom'
require 'uri'
require 'addressable/uri'
require 'aescrypt'
require 'base64'
require File.join(File.dirname(__FILE__), 'environment')

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
  DataMapper.finalize
end


configure :production do
  DataMapper.auto_upgrade!
  before do
    puts '[Params]'
    p params
  end
end


error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error - ' + env['sinatra.error'].message
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def random_string(length)
    SecureRandom.urlsafe_base64
  end

  def get_site_url(short_url)
    SiteConfig.url_base + short_url
  end

  def generate_short_url(long_url)
    @shortcode = random_string 15
    password = "pass"
    encrypted_data = AESCrypt.encrypt(long_url, password)
    #binding.pry
    su = ShortURL.first_or_create(
        { :url => encrypted_data,
          :short_url  =>  @shortcode,
          :created_at =>  Time.now,
          :updated_at =>  Time.now
        })
    get_site_url(su.url)
    redirect '/'
    # url = get_site_url(su.url)
    # uri = Addressable::URI.parse(url)
    # uri.path
    # uri.normalized_path
    #binding.pry
  end
end


get '/' do
  if params[:url] and not params[:url].empty?
    generate_short_url(params[:url])
  else
    @urls = ShortURL.all;
    erb :index
  end

end

post '/' do
  if params[:url] and not params[:url].empty?
    generate_short_url(params[:url])
  else
    @urls = ShortURL.all;
    erb :index
  end
end

["/get/:short_url", "/:short_url"].each do |path|
get path do
  @URLData = ShortURL.get(params[:short_url])
  if @URLData

    ct = ClickTrack.new
    ct.attributes = {
      :short_url  =>  params[:short_url],
      :url    =>  @URLData.url,
      :clicked_at =>  Time.now
    }
    ct.save
    #@one_min = ct.clicked_at + (1.0/(24*60))
    #binding.pry
    erb :show
  else
    'not found'
  end
 end
end

get '/expand/:hash/?' do
  @URLData = ShortURL.get(params[:hash])
  if @URLData
    ct = ClickTrack.all(:short_url => @URLData.short_url)
    content_type :json
    {:url => get_site_url(@URLData.short_url),
     :long_url => @URLData.url,
     :hash => params[:hash],
     :num_followed => ct.count,
     :created_at => @URLData.created_at
    }.to_json
  else
    content_type :json
    { :message => 'No hash parameter was specified or no short URL was found to match the provided hash' }.to_json
  end
end
