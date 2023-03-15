note
	description: "[
		[$source EL_OCCURRENCE_INTERVALS] applied to a target string conforming to
		[$source READABLE_STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 15:29:25 GMT (Wednesday 15th March 2023)"
	revision: "2"

class
	EL_APPLIED_OCCURRENCE_INTERVALS [S -> READABLE_STRING_GENERAL create make end]

inherit
	EL_OCCURRENCE_INTERVALS
		redefine
			is_equal, make_empty, make_by_string, make, fill, fill_by_string
		end

feature {NONE} -- Initialization

	make (a_target: S; delimiter: CHARACTER_32)
		do
			make_empty
			fill (a_target, delimiter, 0)
		end

	make_adjusted (a_target: S; delimiter: CHARACTER_32; a_adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (a_adjustments)
		do
			make_empty
			fill (a_target, delimiter, a_adjustments)
		end

	make_adjusted_by_string (a_target: S; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (a_adjustments)
		do
			make_empty
			fill_by_string (a_target, delimiter, a_adjustments)
		end

	make_by_string (a_target: S; delimiter: READABLE_STRING_GENERAL)
		do
			make_empty
			fill_by_string (a_target, delimiter, 0)
		end

	make_empty
		do
			Precursor
			if not attached target then
				target := default_target
			end
		end

feature -- Element change

	fill_general (a_target: READABLE_STRING_GENERAL; pattern: CHARACTER_32; a_adjustments: INTEGER)
		do
			if attached {like target} a_target as l_target then
				fill (l_target, pattern, a_adjustments)
			end
		end

	fill_general_by_string (a_target, pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			if attached {like target} a_target as l_target then
				fill_by_string (l_target, pattern, a_adjustments)
			end
		end

	fill (a_target: S; pattern: CHARACTER_32; a_adjustments: INTEGER)
		do
			set_target (a_target, a_adjustments)
			fill_intervals (a_target, Empty_string_8, String_8_searcher, pattern, a_adjustments)
		end

	fill_by_string (a_target: S; pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			set_target (a_target, a_adjustments)
			Precursor (a_target, pattern, a_adjustments)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := target ~ other.target and then Precursor {EL_OCCURRENCE_INTERVALS} (other)
		end

feature {NONE} -- Implementation

	default_target: S
		do
			create Result.make (0)
		end

	set_target (a_target: S; a_adjustments: INTEGER)
		do
			target := a_target; adjustments := a_adjustments
		end

feature {EL_APPLIED_OCCURRENCE_INTERVALS} -- Internal attributes

	adjustments: INTEGER

	target: S

end