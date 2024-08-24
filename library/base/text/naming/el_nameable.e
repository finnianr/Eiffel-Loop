note
	description: "Object that is nameable with string conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-24 17:01:05 GMT (Saturday 24th August 2024)"
	revision: "11"

deferred class
	EL_NAMEABLE [S -> READABLE_STRING_GENERAL]

feature -- Access

	name: S
		deferred
		end

end