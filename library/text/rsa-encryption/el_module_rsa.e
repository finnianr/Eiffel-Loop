note
	description: "Module rsa"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:08:44 GMT (Monday 12th November 2018)"
	revision: "6"

class
	EL_MODULE_RSA

inherit
	EL_MODULE

feature {NONE} -- Constants

	Rsa: EL_RSA_ROUTINES
		once
			create Result
		end
end
