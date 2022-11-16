note
	description: "String 8 io medium line source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_STRING_8_IO_MEDIUM_LINE_SOURCE

inherit
	EL_PLAIN_TEXT_LINE_SOURCE
		rename
			make as make_from_path,
			make_from_file as make
		redefine
			Default_file
		end

create
	make_default, make

feature {NONE} -- Constants

	Default_file: EL_STRING_8_IO_MEDIUM
		once
			create Result.make (0)
		end

end