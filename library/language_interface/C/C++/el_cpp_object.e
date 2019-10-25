note
	description: "Cpp object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-07 12:53:56 GMT (Monday   7th   October   2019)"
	revision: "6"

deferred class
	EL_CPP_OBJECT

inherit
	EL_C_OBJECT
		rename
			c_free as cpp_delete
		end

end
