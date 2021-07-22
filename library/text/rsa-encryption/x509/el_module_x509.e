note
	description: "Module x509 command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-22 10:12:21 GMT (Thursday 22nd July 2021)"
	revision: "7"

deferred class
	EL_MODULE_X509

inherit
	EL_MODULE

feature {NONE} -- Constants

	X509_certificate: EL_X509_ROUTINES
		once
			create Result
		end

end