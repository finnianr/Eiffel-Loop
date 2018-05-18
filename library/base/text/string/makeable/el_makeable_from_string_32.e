note
	description: "Summary description for {EL_MAKEABLE_FROM_ZSTRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-04 12:40:42 GMT (Friday 4th May 2018)"
	revision: "2"

deferred class
	EL_MAKEABLE_FROM_STRING_32

inherit
	EL_MAKEABLE_FROM_STRING_GENERAL

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): STRING_32
		do
			Result := general.to_string_32
		end
end
