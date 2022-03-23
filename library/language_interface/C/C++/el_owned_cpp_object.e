note
	description: "Owned cpp object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-23 11:06:45 GMT (Wednesday 23rd March 2022)"
	revision: "2"

deferred class
	EL_OWNED_CPP_OBJECT

inherit
	EL_CPP_OBJECT

	EL_OWNED_C_OBJECT
		rename
			c_free as cpp_delete
		end

end