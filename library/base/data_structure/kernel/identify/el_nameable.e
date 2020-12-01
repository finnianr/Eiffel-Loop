note
	description: "Object that is nameable with string conforming to `READABLE_STRING_GENERAL'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-30 9:59:24 GMT (Monday 30th November 2020)"
	revision: "7"

deferred class
	EL_NAMEABLE [S -> READABLE_STRING_GENERAL]

feature -- Access

	name: S
		deferred
		end

end