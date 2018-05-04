note
	description: "Summary description for {EL_MAKEABLE_FROM_ZSTRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-22 13:34:24 GMT (Friday 22nd December 2017)"
	revision: "1"

deferred class
	EL_MAKEABLE_FROM_STRING_8

inherit
	EL_MAKEABLE_FROM_STRING_GENERAL

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): STRING_8
		do
			Result := general.to_string_8
		end
end
