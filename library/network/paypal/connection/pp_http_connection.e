note
	description: "Pp http connection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

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

	make (a_cert_authority_info_path: EL_FILE_PATH)
		do
			cert_authority_info_path := a_cert_authority_info_path
			make_connection
		end

feature -- Basic operations

	open (a_url: like url)
		do
			Precursor (a_url)

			set_http_version (1.1)
			set_ssl_tls_version (1.2)
			set_ssl_certificate_verification (True)
			set_ssl_hostname_verification (True)
			set_certificate_authority_info (cert_authority_info_path)
			headers ["Connection"] := "Close"
		end

feature {NONE} -- Internal attributes

	cert_authority_info_path: EL_FILE_PATH

end
