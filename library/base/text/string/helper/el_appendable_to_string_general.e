note
	description: "[
		Object that can append a text representation of it self to a string conforming to
		[$source STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 8:58:45 GMT (Friday 9th December 2022)"
	revision: "1"

deferred class
	EL_APPENDABLE_TO_STRING_GENERAL

feature -- Basic operations

	append_to (str: STRING_GENERAL)
		deferred
		end
end