note
	description: "Zstring io medium line source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_ZSTRING_IO_MEDIUM_LINE_SOURCE

inherit
	EL_FILE_LINE_SOURCE

	EL_ZSTRING_CONSTANTS

create
	make_default, make

feature {NONE} -- Implementation

	update_item
		do
			item := file.last_string
		end

feature {NONE} -- Constants

	Default_file: EL_ZSTRING_IO_MEDIUM
		once
			create Result.make (0)
		end
end