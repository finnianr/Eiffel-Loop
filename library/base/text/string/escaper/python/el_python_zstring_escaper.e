note
	description: "Summary description for {EL_PYTHON_ZSTRING_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-10 13:49:26 GMT (Tuesday 10th April 2018)"
	revision: "2"

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
