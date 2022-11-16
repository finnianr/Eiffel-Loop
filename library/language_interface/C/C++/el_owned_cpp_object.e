note
	description: "Owned cpp object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_OWNED_CPP_OBJECT

inherit
	EL_CPP_OBJECT

	EL_OWNED_C_OBJECT
		rename
			c_free as cpp_delete
		end

end