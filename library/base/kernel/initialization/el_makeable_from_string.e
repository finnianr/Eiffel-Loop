note
	description: "Object is makeable from string conforming to ${STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-22 5:26:21 GMT (Saturday 22nd June 2024)"
	revision: "8"

deferred class
	EL_MAKEABLE_FROM_STRING [S-> STRING_GENERAL create make end]

inherit
	EL_MAKEABLE
		rename
			make as make_default
		end

	EL_STRING_GENERAL_ROUTINES

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
			if is_zstring (general) then
				as_zstring (general).append_to_general (Result)
			else
				Result.append (general)
			end
		end

end