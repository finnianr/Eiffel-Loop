note
	description: "Summary description for {EL_REFLECTED_STRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-25 16:11:14 GMT (Wednesday 25th April 2018)"
	revision: "3"

deferred class
	EL_REFLECTED_STRING

inherit
	EL_REFLECTED_REFERENCE
		undefine
			initialize_default
		redefine
			default_defined
		end

feature {NONE} -- Constants

	Default_defined: BOOLEAN = True

end
