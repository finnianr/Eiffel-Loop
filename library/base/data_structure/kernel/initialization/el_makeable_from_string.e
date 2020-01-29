note
	description: "Makeable from string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 15:00:45 GMT (Wednesday 29th January 2020)"
	revision: "1"

deferred class
	EL_MAKEABLE_FROM_STRING [S-> STRING_GENERAL create make end]

inherit
	EL_MAKEABLE
		rename
			make as make_default
		end

	DEBUG_OUTPUT

feature -- Initialization

	make (string: like new_string)
		deferred
		end

	make_from_general (general: READABLE_STRING_GENERAL)
		do
			if attached {like new_string} general as string then
				make (string)
			else
				make (new_string (general))
			end
		end

feature -- Conversion

	to_string: like new_string
		deferred
		end

	debug_output: STRING_32
		do
			Result := to_string.as_string_32
		end

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): S
		do
			create Result.make (general.count)
			if attached {ZSTRING} general as zstr then
				zstr.append_to_general (Result)
			else
				Result.append (general)
			end
		end

end
