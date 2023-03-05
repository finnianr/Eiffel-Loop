note
	description: "[$source EL_STRING_8] argument wrappers for [$source EL_READABLE_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-05 10:47:32 GMT (Sunday 5th March 2023)"
	revision: "11"

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
			string_searcher := area [0].string_searcher
		end

feature -- Status query

	ends_with (target, other: EL_COMPARABLE_ZSTRING): BOOLEAN
		do
			Result := injected (target, 0).ends_with (injected (other, 1))
		end

	has (target: EL_ZSTRING_IMPLEMENTATION; c: CHARACTER_8): BOOLEAN
			-- Does string include `c'?
		do
			Result := injected (target, 0).has (c)
		end

	same_caseless_characters (target, other: EL_COMPARABLE_ZSTRING; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
		do
			Result := injected (target, 0).same_caseless_characters (injected (other, 1), start_pos, end_pos, index_pos)
		end

	starts_with (target, other: EL_COMPARABLE_ZSTRING): BOOLEAN
		do
			Result := injected (target, 0).starts_with (injected (other, 1))
		end

feature -- Measurement

	occurrences (target: EL_ZSTRING_IMPLEMENTATION; c: CHARACTER_8): INTEGER
			-- Number of times `c' appears in the string
		do
			Result := injected (target, 0).occurrences (c)
		end

feature -- Concatenation

	append_string_8 (a_target: EL_APPENDABLE_ZSTRING; str: READABLE_STRING_8)
		do
			if attached injected (a_target, 0) as target then
				target.append (str)
				a_target.set_from_string_8 (target)
			end
		end

	append_substring (a_target, s: EL_APPENDABLE_ZSTRING; start_index, end_index: INTEGER)
		do
			if attached injected (a_target, 0) as target then
				target.append_substring (injected (s, 1), start_index, end_index)
				a_target.set_from_string_8 (target)
			end
		end

	prepend_character (a_target: EL_PREPENDABLE_ZSTRING; c: CHARACTER_8)
		-- Add `c' at front.
		do
			if attached injected (a_target, 0) as target then
				target.prepend_character (c)
				a_target.set_from_string_8 (target)
			end
		end

	prepend (a_target: EL_PREPENDABLE_ZSTRING; str: READABLE_STRING_8)
		do
			if attached injected (a_target, 0) as target then
				target.prepend (str)
				a_target.set_from_string_8 (target)
			end
		end

	prepend_substring (a_target, s: EL_PREPENDABLE_ZSTRING; start_index, end_index: INTEGER)
		do
			if attached injected (a_target, 0) as target then
				target.prepend_substring (injected (s, 1), start_index, end_index)
				a_target.set_from_string_8 (target)
			end
		end

feature -- Transformation

	insert_character (a_target: ZSTRING; c: CHARACTER; i: INTEGER)
		do
			if attached injected (a_target, 0) as target then
				target.insert_character (c, i)
				a_target.set_from_string_8 (target)
			end
		end

	make_from_string (target: EL_READABLE_ZSTRING; s: READABLE_STRING_8)
		-- initialize with string that has the same encoding as codec
		local
			str: EL_STRING_8
		do
			create str.make_from_string (s)
			target.set_from_string_8 (str)
		end

	mirror (a_target: EL_TRANSFORMABLE_ZSTRING)
		do
			if attached injected (a_target, 0) as target then
				target.mirror
				a_target.set_from_string_8 (target)
			end
		end

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

feature -- Character removal

	prune_all (a_target: ZSTRING; c: CHARACTER)
		do
			if attached injected (a_target, 0) as target then
				target.prune_all (c)
				a_target.set_from_string_8 (target)
			end
		end

	remove_substring (a_target: EL_ZSTRING; start_index, end_index: INTEGER)
		-- Remove all characters from `start_index' to `end_index' inclusive.
		do
			if attached injected (a_target, 0) as target then
				target.remove_substring (start_index, end_index)
				a_target.set_from_string_8 (target)
			end
		end

feature -- Search

	fill_index_list (
		list: ARRAYED_LIST [INTEGER]; a_target: EL_SEARCHABLE_ZSTRING; pattern: READABLE_STRING_8
	)
		local
			target: EL_STRING_8; index, count, pattern_count: INTEGER
		do
			target := injected (a_target, 0)
			pattern_count := pattern.count; count := target.count
			if attached string_searcher as searcher then
				searcher.initialize_deltas (pattern)
				from index := 1 until index = 0 or else index > count - pattern_count + 1 loop
					index := searcher.substring_index_with_deltas (target, pattern, index, count)
					if index > 0 then
						list.extend (index)
						index := index + pattern_count
					end
				end
			end
		end

	substring_index (target, other: EL_SEARCHABLE_ZSTRING; start_index: INTEGER): INTEGER
		do
			Result := string_searcher.substring_index (
				injected (target, 0), injected (other, 1), start_index, target.count
			)
		end

	substring_index_ascii (target: EL_SEARCHABLE_ZSTRING; ascii_other: READABLE_STRING_8; start_index: INTEGER): INTEGER
		do
			Result := string_searcher.substring_index (
				injected (target, 0), ascii_other, start_index, target.count
			)
		end

	substring_index_in_bounds (target, other: EL_SEARCHABLE_ZSTRING; start_pos, end_pos: INTEGER): INTEGER
		do
			Result := string_searcher.substring_index (injected (target, 0), injected (other, 1), start_pos, end_pos)
		end

	substring_index_in_bounds_ascii (
		target: EL_SEARCHABLE_ZSTRING; ascii_other: READABLE_STRING_8; start_pos, end_pos: INTEGER
	): INTEGER
		do
			Result := string_searcher.substring_index (injected (target, 0), ascii_other, start_pos, end_pos)
		end

feature -- Access

	c_string (latin_1_ptr: POINTER): EL_STRING_8
		do
			Result := area [0]
			Result.set_from_c (latin_1_ptr)
		end

	injected (zstr: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; i: INTEGER): EL_STRING_8
		require
			valid_index: valid_index (i)
		do
			Result := area [i]
			Result.set_area_and_count (zstr.area, zstr.count)
		end

feature -- Contract Support

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := area.valid_index (i)
		end

feature {EL_SEARCHABLE_ZSTRING} -- Internal attributes

	area: SPECIAL [EL_STRING_8]

	string_searcher: STRING_8_SEARCHER
end