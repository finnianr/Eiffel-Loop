note
	description: "Ancestor for classes that primarly provide access to a shared instance of a class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-08 9:20:59 GMT (Monday 8th July 2019)"
	revision: "5"

deferred class
	EL_ANY_SHARED

inherit
	ANY
		undefine
			copy, default_create, is_equal, out
		end

end
