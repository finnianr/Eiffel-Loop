note
	description: "Ancestor for classes that primarly provide access to a shared instance of a class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

deferred class
	EL_ANY_SHARED

inherit
	ANY
		undefine
			copy, default_create, is_equal, out
		end

end
