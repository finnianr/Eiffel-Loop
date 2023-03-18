note
	description: "[
		Absraction for descendants [$source EL_OCCURRENCE_EDITOR] and [$source EL_SPLIT_STRING_LIST]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-18 9:49:52 GMT (Saturday 18th March 2023)"
	revision: "20"

deferred class
	EL_STRING_OCCURRENCE_IMPLEMENTATION [S -> READABLE_STRING_GENERAL]

inherit
	ANY
		undefine
			copy, is_equal, out
		end

feature -- Element change

	fill_by_string (a_target: S; a_pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		deferred
		end

feature {NONE} -- Implementation

	fill_intervals (
		a_target, a_pattern: READABLE_STRING_GENERAL; searcher: STRING_SEARCHER
		uc: CHARACTER_32; adjustments: INTEGER
	)
		deferred
		end

	is_valid_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := True
		end

	set_target (a_target: S; a_adjustments: INTEGER)
		deferred
		end

	target: S
		deferred
		end

end