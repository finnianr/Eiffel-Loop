note
	description: "Paypal HTTP connection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-15 12:11:16 GMT (Saturday 15th November 2025)"
	revision: "12"

class
	PP_HTTP_CONNECTION

inherit
	EL_HTTP_CONNECTION
		rename
			make as make_connection
		redefine
			open_url
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

	open_url (a_url: like url)
		do
			Precursor (a_url)

			set_http_version (1_1)
			set_tls_version (1_2)
			set_certificate_verification (True)
			set_hostname_verification (True)
			set_certificate_authority_info (Configuration.cert_authority_info_path)
			curl.put_request_header ("Connection", "Close")
		end

end