note
	description: "Tl mpeg file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-25 18:20:36 GMT (Friday   25th   October   2019)"
	revision: "1"

class
	TL_MPEG_FILE

inherit
	EL_CPP_OBJECT

	TL_MPEG_FILE_CPP_API

	EL_SHARED_ONCE_ZSTRING

feature {NONE} -- Implementation

	make (path: EL_FILE_PATH)
		local
			file_name: TL_FILE_NAME; str: ZSTRING
		do
			str := empty_once_string; path.append_to (str)
			create file_name.make (str)
			make_from_pointer (cpp_new (file_name.item))
		end
end
