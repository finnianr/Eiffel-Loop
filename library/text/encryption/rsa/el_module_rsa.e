note
	description: "Summary description for {EL_MODULE_RSA}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_MODULE_RSA

inherit
	EL_MODULE

feature -- Access

	rsa: EL_RSA_ROUTINES
		once
			create Result
		end
end
