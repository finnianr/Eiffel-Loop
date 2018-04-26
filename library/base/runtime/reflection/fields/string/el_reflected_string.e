note
	description: "Summary description for {EL_REFLECTED_STRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-17 13:52:59 GMT (Wednesday 17th January 2018)"
	revision: "2"

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
