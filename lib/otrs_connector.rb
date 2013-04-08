require 'net/https'

module OtrsConnector
	def initialize_for_app(host, path, user, pass, configuration = {})
		$otrs_host = host
    $otrs_api_url = "http://#{$otrs_host}#{path}"
    $otrs_user = user
    $otrs_pass = pass
    $configuration = configuration

		Dir.glob(File.join(File.dirname(__FILE__), '..', 'lib', 'otrs_connector', '*.rb')).each {|f| require f }
		Dir.glob(File.join(File.dirname(__FILE__), '..', 'lib', 'otrs_connector', 'otrs', '*.rb')).each {|f| require f }
		Dir.glob(File.join(File.dirname(__FILE__), '..', 'lib', 'otrs_connector', 'otrs', '**', '*.rb')).each {|f| require f }
	end

  module_function :initialize_for_app
end
