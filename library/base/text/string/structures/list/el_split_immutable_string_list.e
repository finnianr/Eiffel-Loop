note
	description: "Splits strings conforming to [$source IMMUTABLE_STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-06 14:41:48 GMT (Sunday 6th August 2023)"
	revision: "3"

deferred class
	EL_SPLIT_IMMUTABLE_STRING_LIST [
		GENERAL -> STRING_GENERAL, IMMUTABLE -> IMMUTABLE_STRING_GENERAL create make end
	]

inherit
	EL_SPLIT_READABLE_STRING_LIST [IMMUTABLE]
		rename
			target_substring as shared_target_substring
		end

feature {NONE} -- Initialization

	make_shared (a_target: GENERAL; delimiter: CHARACTER_32)
		do
			make (new_shared (a_target), delimiter)
		end

	make_shared_adjusted (a_target: GENERAL; delimiter: CHARACTER_32; a_adjustments: INTEGER)
		do
			make_adjusted (new_shared (a_target), delimiter, a_adjustments)
		end

	make_shared_adjusted_by_string (a_target: GENERAL; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			make_adjusted_by_string (new_shared (a_target), delimiter, a_adjustments)
		end

	make_shared_by_string (a_target: GENERAL; delimiter: READABLE_STRING_GENERAL)
		do
			make_by_string (new_shared (a_target), delimiter)
		end

feature {NONE} -- Implementation

	new_shared (a_target: GENERAL): IMMUTABLE
		deferred
		end

end