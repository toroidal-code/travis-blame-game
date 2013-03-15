#Encodng.default_external = 'utf-8'

require "sinatra"
require "rubygems"
require "bundler/setup"
require 'sinatra/support'
require 'sinatra/assetpack'
require './helper'

#configure { set :server, :puma }

#Using gzip compression in Sinatra with Ruby
#z = Zlib::Deflate.new(6, 31)
#z.deflate(File.read('public/Assets/Styles/build.css'))
#z.flush
#@result = z.finish # could also of done: result = z.deflate(file, Zlib::FINISH)
#z.close

class App < Sinatra::Base
  register Sinatra::CompassSupport
  set :root, File.dirname(__FILE__)
  register Sinatra::AssetPack
  @repo = "rit-sse/rapdev13"
  helper = Helper.new(@repo,5)

  assets do
    serve '/js',  from: 'app/js'
    serve '/css', from: 'app/css'
    serve '/img', from: 'app/img'

    
    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    js :app, '/js/app.js', [
			    '/js/jquery.min.js',
			    '/js/bootstrap.js'
			   ]
    
    css :application, '/css/application.css', [
                 '/css/add.css',
					       '/css/bootstrap.css',
					       '/css/bootstrap-responsive.min.css'
					      ]
    
    js_compression	:jsmin
    css_compression :sass
    prebuild true
  end
  
  configure do
    #set :public_folder, Proc.new { File.join(root, "public")}
  end

  get '/' do
      erb :index, locals: {branches: helper.branches}
  end

  Helper::repeat_every 5 do
    helper.rapdev.reload
    helper.branches_reload
  end

end
