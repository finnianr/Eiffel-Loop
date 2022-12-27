note
	description: "Python [$source ZSTRING] escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-27 8:42:06 GMT (Tuesday 27th December 2022)"
	revision: "6"

class
	EL_PYTHON_ZSTRING_ESCAPER

inherit
	EL_PYTHON_GENERAL_ESCAPER

	EL_ZSTRING_ESCAPER
		rename
			make as make_escaper
		end

create
	make

end