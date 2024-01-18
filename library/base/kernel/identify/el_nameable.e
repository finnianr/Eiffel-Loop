note
	description: "Object that is nameable with string conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "9"

deferred class
	EL_NAMEABLE [S -> READABLE_STRING_GENERAL]

feature -- Access

	name: S
		deferred
		end

end