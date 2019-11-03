note
	description: "Owned cpp object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 9:55:22 GMT (Saturday 26th October 2019)"
	revision: "1"

deferred class
	EL_OWNED_CPP_OBJECT

inherit
	EL_CPP_OBJECT

	EL_OWNED_C_OBJECT
		rename
			c_free as cpp_delete
		end

end
