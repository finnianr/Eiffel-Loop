note
	description: "TagLib file name interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 15:34:01 GMT (Friday 8th January 2021)"
	revision: "3"

deferred class
	TL_FILE_NAME_I

feature {NONE} -- Initialization

	make (path: EL_FILE_PATH)
		local
			str: ZSTRING; buffer: EL_ZSTRING_BUFFER_ROUTINES
		do
			str := buffer.empty; path.append_to (str)
			make_from_string (str)
		end

	make_from_string (name: ZSTRING)
		deferred
		end
end