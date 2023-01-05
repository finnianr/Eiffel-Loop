note
	description: "Bash path string 8 escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_BASH_PATH_STRING_8_ESCAPER

inherit
	EL_BASH_PATH_GENERAL_ESCAPER

	EL_STRING_8_ESCAPER
		rename
			make as make_escaper
		end

create
	make
end