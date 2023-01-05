note
	description: "Bash path zstring escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_BASH_PATH_ZSTRING_ESCAPER

inherit
	EL_BASH_PATH_GENERAL_ESCAPER

	EL_ZSTRING_ESCAPER
		rename
			make as make_escaper
		end

create
	make

end