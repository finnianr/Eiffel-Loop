note
	description: "Summary description for {EL_MAKEABLE_FROM_ZSTRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-25 16:27:55 GMT (Wednesday 25th April 2018)"
	revision: "2"

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
