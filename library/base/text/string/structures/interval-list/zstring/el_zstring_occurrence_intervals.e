note
	description: "[
		${EL_OCCURRENCE_INTERVALS} optimized for strings of type ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-12 12:21:36 GMT (Friday 12th April 2024)"
	revision: "8"

class
	EL_ZSTRING_OCCURRENCE_INTERVALS

inherit
	EL_OCCURRENCE_INTERVALS
		redefine
			fill_by_string
		end

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make, make_empty, make_by_string, make_sized, make_from_special

feature -- Element change

	fill_by_string (target: EL_READABLE_ZSTRING; pattern: READABLE_STRING_GENERAL; adjustments: INTEGER)
		do
			if pattern.count = 1 then
				fill_intervals (target, Empty_string, String_searcher, pattern [1], adjustments)
			else
				fill_by_zstring (target, pattern, adjustments)
			end
		end

end