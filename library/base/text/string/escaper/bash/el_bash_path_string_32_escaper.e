note
	description: "Summary description for {EL_BASH_PATH_STRING_32_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-08 13:43:20 GMT (Sunday 8th April 2018)"
	revision: "2"

class
	EL_BASH_PATH_STRING_32_ESCAPER

inherit
	EL_BASH_PATH_GENERAL_ESCAPER

	EL_STRING_32_ESCAPER
		rename
			make as make_escaper
		end

create
	make
end
