note
	description: "Bash path general escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-04 12:20:47 GMT (Wednesday 4th January 2023)"
	revision: "9"

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
			make_escaper ("<>(){}[] '`%"\!?&|^$:;,")
		end

end