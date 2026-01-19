note
	description: "Makeable from zstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "5"

deferred class
	EL_MAKEABLE_FROM_ZSTRING

inherit
	EL_MAKEABLE_FROM_STRING_GENERAL

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): ZSTRING
		do
			if attached {ZSTRING} general as l_result then
				Result := l_result
			else
				create Result.make_from_general (general)
			end
		end
end
