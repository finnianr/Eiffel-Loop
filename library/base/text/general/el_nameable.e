note
	description: "Nameable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-28 9:48:58 GMT (Saturday 28th November 2020)"
	revision: "6"

deferred class
	EL_NAMEABLE [S -> READABLE_STRING_GENERAL]

feature -- Access

	name: S
		deferred
		end

end