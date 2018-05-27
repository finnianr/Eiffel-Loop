note
	description: "Module rsa"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "4"

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