note
	description: "Shared access to instance of ${EL_X509_CERTIFICATE_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "11"

deferred class
	EL_MODULE_X509

inherit
	EL_MODULE

feature {NONE} -- Constants

	X509_certificate: EL_X509_CERTIFICATE_ROUTINES
		once
			create Result
		end

end