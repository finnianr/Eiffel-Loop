note
	description: "Summary description for {EL_RSA_KEY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_RSA_KEY

inherit
	EL_MODULE_BASE_64

	EL_MODULE_RSA

feature {NONE} -- Implementation

	Default_exponent: INTEGER_X
		once
			create Result.make_from_integer (65537)
		end

end
