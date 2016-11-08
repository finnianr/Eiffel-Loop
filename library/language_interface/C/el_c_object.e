note
	description: "Summary description for {EL_C_OBJECT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-03 11:52:07 GMT (Monday 3rd October 2016)"
	revision: "2"

deferred class
	EL_C_OBJECT

inherit
	EL_CPP_OBJECT
		rename
			cpp_delete as c_free
		end

end
