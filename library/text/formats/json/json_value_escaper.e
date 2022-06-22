note
	description: "Json value escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-22 8:28:00 GMT (Wednesday 22nd June 2022)"
	revision: "4"

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

