note
	description: "Summary description for {EL_C_OBJECT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_C_OBJECT

inherit
	EL_CPP_OBJECT
		rename
			cpp_delete as c_free
		end

end
