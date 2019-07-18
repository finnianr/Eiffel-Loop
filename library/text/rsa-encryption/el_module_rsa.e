note
	description: "Module rsa"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:56:02 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_MODULE_RSA

inherit
	EL_MODULE

feature {NONE} -- Constants

	Rsa: EL_RSA_ROUTINES
		once
			create Result
		end
end
