note
	description: "Summary description for {EL_JSON_VALUE_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-08 14:23:21 GMT (Sunday 8th April 2018)"
	revision: "1"

class
	EL_JSON_VALUE_ESCAPER

inherit
	EL_JSON_GENERAL_ESCAPER

	EL_ZSTRING_ESCAPER
		rename
			make as make_escaper
		end

create
	make

end
