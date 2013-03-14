#\ -s puma
require 'rack/cache'

use Rack::Deflater

use Rack::Cache,
    :metastore   => 'file:/var/cache/rack/meta',
    :entitystore => 'file:/var/cache/rack/body',
    :verbose     => true

require './app'
run App
