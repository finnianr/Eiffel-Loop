note
	description: "[$source EL_STRING_8] argument wrappers for [$source EL_READABLE_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-07 12:52:19 GMT (Tuesday 7th February 2023)"
	revision: "1"

class
	EL_STRING_8_IMPLEMENTATION

create
	make

feature {NONE} -- Initialization

	make
		do
			create area.make_empty (3)
			from until area.count = 3 loop
				area.extend (create {EL_STRING_8}.make_empty)
			end
		end

feature -- Status query

	ends_with (target, other: EL_COMPARABLE_ZSTRING): BOOLEAN
		do
			Result := injected (target, 0).ends_with (injected (other, 1))
		end

	same_caseless_characters (target, other: EL_COMPARABLE_ZSTRING; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
		do
			Result := injected (target, 0).same_caseless_characters (injected (other, 1), start_pos, end_pos, index_pos)
		end

feature -- Transformation

	replace_substring (a_target, other: EL_TRANSFORMABLE_ZSTRING; start_index, end_index: INTEGER)
		do
			if attached injected (a_target, 0) as target then
				target.replace_substring (injected (other, 1), start_index, end_index)
				a_target.set_from_string_8 (target)
			end
		end

	replace_substring_all (a_target, old_substring, new_substring: EL_TRANSFORMABLE_ZSTRING)
		do
			if attached injected (a_target, 0) as target then
				target.replace_substring_all (injected (old_substring, 1), injected (new_substring, 2))
				a_target.set_from_string_8 (target)
			end
		end

feature -- Search

	substring_index (target, other: EL_SEARCHABLE_ZSTRING; start_index: INTEGER): INTEGER
		require
			valid_content: target.has_mixed_encoding implies not other.has_mixed_encoding
			valid_content: not (target.has_mixed_encoding and other.has_mixed_encoding)
		do
			Result := injected (target, 0).substring_index (injected (other, 1), start_index)
		end

	substring_index_in_bounds (target, other: EL_SEARCHABLE_ZSTRING; start_pos, end_pos: INTEGER): INTEGER
		require
			valid_content: target.has_mixed_encoding implies not other.has_mixed_encoding
			valid_content: not (target.has_mixed_encoding and other.has_mixed_encoding)
		do
			Result := injected (target, 0).substring_index_in_bounds (injected (other, 1), start_pos, end_pos)
		end

feature {NONE} -- Implementation

	injected (zstr: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; i: INTEGER): EL_STRING_8
		require
			valid_index: area.valid_index (i)
		do
			Result := area [i]
			Result.set_area_and_count (zstr.area, zstr.count)
		end

feature {NONE} -- Initialization

	area: SPECIAL [EL_STRING_8]
end