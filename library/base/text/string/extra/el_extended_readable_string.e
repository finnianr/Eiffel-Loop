note
	description: "Extends the features of strings conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 14:28:59 GMT (Saturday 19th April 2025)"
	revision: "3"

deferred class
	EL_EXTENDED_READABLE_STRING [CHAR -> COMPARABLE]

inherit
	EL_EXTENDED_READABLE_STRING_I [CHAR]

feature {NONE} -- Initialization

	make (t: like target)
		do
			set_target (t)
		end

	make_empty
		deferred
		end

end