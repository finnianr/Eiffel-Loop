note
	description: "Paypal HTTP connection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-22 11:09:38 GMT (Tuesday 22nd June 2021)"
	revision: "6"

class
	PP_HTTP_CONNECTION

inherit
	EL_HTTP_CONNECTION
		rename
			make as make_connection
		redefine
			open
		end

create
	make

feature {NONE} -- Initialization

	make (a_configuration: PP_CONFIGURATION)
		do
			make_connection
			configuration := a_configuration
		end

feature -- Access

	configuration: PP_CONFIGURATION

feature -- Basic operations

	open (a_url: like url)
		do
			Precursor (a_url)

			set_http_version (1.1)
			set_ssl_tls_version (1.2)
			set_ssl_certificate_verification (True)
			set_ssl_hostname_verification (True)
			set_certificate_authority_info (Configuration.cert_authority_info_path)
			headers ["Connection"] := "Close"
		end

end