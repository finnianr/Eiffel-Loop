note
	description: "Tl file name i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 9:46:02 GMT (Tuesday 5th January 2021)"
	revision: "2"

deferred class
	TL_FILE_NAME_I

inherit
	EL_SHARED_ONCE_ZSTRING

feature {NONE} -- Initialization

	make (path: EL_FILE_PATH)
		local
			str: ZSTRING
		do
			str := once_empty_string; path.append_to (str)
			make_from_string (str)
		end

	make_from_string (name: ZSTRING)
		deferred
		end
end