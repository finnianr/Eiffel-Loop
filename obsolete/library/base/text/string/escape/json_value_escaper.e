note
	description: "Json value escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	JSON_VALUE_ESCAPER

inherit
	JSON_GENERAL_ESCAPER

	EL_ZSTRING_ESCAPER
		rename
			make as make_escaper
		end

create
	make

end