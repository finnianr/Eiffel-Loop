note
	description: "Bash path general escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

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