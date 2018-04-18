note
	description: "Summary description for {EL_BASH_PATH_CHARACTER_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-08 13:42:49 GMT (Sunday 8th April 2018)"
	revision: "4"

deferred class
	EL_BASH_PATH_GENERAL_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER
		rename
			make as make_escaper
		end

feature {NONE} -- Initialization

	make
		do
			make_escaper ("<>(){}[]'`%"\!?&|^$:;, ")
		end

end
