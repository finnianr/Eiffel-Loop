note
	description: "Tl file name i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-11 15:22:55 GMT (Wednesday 11th March 2020)"
	revision: "1"

deferred class
	TL_FILE_NAME_I

inherit
	EL_SHARED_ONCE_ZSTRING

feature {NONE} -- Initialization

	make (path: EL_FILE_PATH)
		local
			str: ZSTRING
		do
			str := empty_once_string; path.append_to (str)
			make_from_string (str)
		end

	make_from_string (name: ZSTRING)
		deferred
		end
end
