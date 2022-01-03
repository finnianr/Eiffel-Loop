note
	description: "TagLib file name interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "4"

deferred class
	TL_FILE_NAME_I

feature {NONE} -- Initialization

	make (path: FILE_PATH)
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