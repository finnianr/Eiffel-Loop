note
	description: "Paypal HTTP connection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-27 12:02:47 GMT (Tuesday 27th August 2019)"
	revision: "5"

class
	PP_HTTP_CONNECTION

inherit
	EL_HTTP_CONNECTION
		redefine
			open
		end

	PP_SHARED_CONFIGURATION

create
	make

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
