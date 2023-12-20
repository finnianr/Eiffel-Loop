note
	description: "Ancestor for classes that primarly provide access to a shared instance of a class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:09:21 GMT (Sunday 5th November 2023)"
	revision: "8"

deferred class
	EL_ANY_SHARED

inherit
	ANY
		undefine
			copy, default_create, is_equal, out
		end

end