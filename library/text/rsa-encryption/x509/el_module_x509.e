note
	description: "Shared access to instance of [$source EL_X509_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-26 11:44:51 GMT (Monday 26th July 2021)"
	revision: "8"

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