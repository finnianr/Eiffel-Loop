note
	description: "TagLib file name interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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