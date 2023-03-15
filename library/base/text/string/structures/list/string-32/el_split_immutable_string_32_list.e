note
	description: "[
		A list of substring index intervals conforming to [$source EL_SPLIT_INTERVALS]
		for a string of type [$source IMMUTABLE_STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 15:34:13 GMT (Wednesday 15th March 2023)"
	revision: "9"

class
	EL_SPLIT_IMMUTABLE_STRING_32_LIST

inherit
	EL_SPLIT_READABLE_STRING_LIST [IMMUTABLE_STRING_32]
		undefine
			fill_by_string, is_valid_character
		redefine
			fill_general, fill_general_by_string, item, i_th
		end

	EL_STRING_32_OCCURRENCE_IMPLEMENTATION [IMMUTABLE_STRING_32]

	EL_SHARED_IMMUTABLE_32_MANAGER

create
	make_by_string, make_adjusted, make_adjusted_by_string,
	make_shared_by_string, make_shared_adjusted, make_shared_adjusted_by_string,
	make_empty, make

feature {NONE} -- Initialization

	make_shared (a_target: STRING_32; delimiter: CHARACTER_32)
		do
			make (new_shared (a_target), delimiter)
		end

	make_shared_adjusted (a_target: STRING_32; delimiter: CHARACTER_32; a_adjustments: INTEGER)
		do
			make_adjusted (new_shared (a_target), delimiter, a_adjustments)
		end

	make_shared_adjusted_by_string (a_target: STRING_32; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			make_adjusted_by_string (new_shared (a_target), delimiter, a_adjustments)
		end

	make_shared_by_string (a_target: STRING_32; delimiter: READABLE_STRING_GENERAL)
		do
			make_by_string (new_shared (a_target), delimiter)
		end

feature -- Access

	item: IMMUTABLE_STRING_32
		-- current iteration split item
		local
			lower, upper: INTEGER
		do
			lower := i_th_lower_upper (index, $upper)
			Result := target.shared_substring (lower, upper)
		end

	i_th (i: INTEGER): IMMUTABLE_STRING_32
		local
			lower, upper: INTEGER
		do
			lower := i_th_lower_upper (i, $upper)
			Result := target.shared_substring (lower, upper)
		end


feature -- Element change

	fill_general (a_target: READABLE_STRING_GENERAL; pattern: CHARACTER_32; a_adjustments: INTEGER)
		do
			if attached {like target} a_target as l_target then
				fill (l_target, pattern, a_adjustments)

			elseif attached {STRING_32} a_target as str_32 then
				fill (new_shared (str_32), pattern, a_adjustments)
			end
		end

	fill_general_by_string (a_target, pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			if attached {like target} a_target as l_target then
				fill_by_string (l_target, pattern, a_adjustments)

			elseif attached {STRING_32} a_target as str_32 then
				fill_by_string (new_shared (str_32), pattern, a_adjustments)
			end
		end

feature {NONE} -- Implementation

	new_shared (a_target: STRING_32): IMMUTABLE_STRING_32
		do
			Result := Immutable_32.new_substring (a_target.area, 0, a_target.count)
		end
end