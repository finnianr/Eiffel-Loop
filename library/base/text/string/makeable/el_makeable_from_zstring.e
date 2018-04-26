note
	description: "Summary description for {EL_MAKEABLE_FROM_ZSTRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-22 13:21:01 GMT (Friday 22nd December 2017)"
	revision: "1"

deferred class
	EL_MAKEABLE_FROM_ZSTRING

inherit
	EL_MAKEABLE_FROM_STRING

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (general)
		end
end
