note
	description: "Defines a dynamic substring view of a string for use with lexers and parsers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 12:18:25 GMT (Sunday 28th July 2013)"
	revision: "3"

class
	EL_STRING_VIEW

inherit
	ANY
		redefine
			default_create
		end

create
	default_create, make_from_other

convert
	view: {STRING}, view_general: {READABLE_STRING_GENERAL}

feature {EL_PARSER, NONE} -- Initialization

	default_create
			--
		do
			create {STRING} text.make_empty
			count := 0
			zero_based_offset := 0
		end

	make_from_other (other: like Current)
			--
		do
			set_from_other (other)
		end

feature -- Access

	view_general: like text
		do
			Result := text.substring (zero_based_offset + 1, zero_based_offset + count)
		end

	view: STRING
			--
		do
			Result := view_general.as_string_8
		end

	view_32: STRING_32
			--
		do
			Result := view_general.as_string_32
		end

	count: INTEGER

	maximum_count: INTEGER
		do
			Result := text.count
		end

feature -- Measurement

	occurrences (c: like item): INTEGER
		local
			l_text: like text
			i: INTEGER
		do
			l_text := text
			from i := 1 until i > count loop
				if l_text.code (zero_based_offset + i) = c then
					Result := Result + 1
				end
				i := i + 1
			end
		end

feature -- Element Change

	set_from_other (other: like Current)
			--
		do
			text := other.text
			zero_based_offset := other.zero_based_offset
			count := other.count
		end

	set_view (a_from_index, a_count: INTEGER)
			--
		require
			valid_index: a_from_index <= maximum_count
			valid_count: a_count <= (maximum_count - a_from_index)
		do
			zero_based_offset := a_from_index
			count := a_count
		end

	set_length (new_count: INTEGER)
			--
		require
			valid_count: valid_count (new_count)
		do
			count := new_count
		end

	set_text (a_text: READABLE_STRING_GENERAL)
			-- Copied from {STRING}.share
		do
			text := a_text
			set_view (0, a_text.count)
		ensure
			shared_count: a_text.count = count
		end

	restore
			-- Restore to full size of shared string
		do
			zero_based_offset := 0
			count := text.count
		end

	prune_leading (count_to_remove: INTEGER)
			--
		require
			are_characters_to_remove: count_to_remove <= count
		do
			zero_based_offset := zero_based_offset + count_to_remove
			count := count - count_to_remove
		ensure
			valid_from_index: zero_based_offset <= text.count
		end

feature -- Query

	item (i: INTEGER): NATURAL_32
			-- Character at position `i'
		do
			Result := text.code (zero_based_offset + i)
		end

	item_absolute_pos (i: INTEGER): INTEGER
			-- Absolute position of i
		do
			Result := zero_based_offset + i
		end

	is_start_of_line: BOOLEAN
			--
		do
			if zero_based_offset = 0 then
				Result := true
			else
				Result := text.code (zero_based_offset) = new_line_character
			end
		end

	starts_with (a_text: READABLE_STRING_GENERAL): BOOLEAN
			--
		local
			i: INTEGER
		do
			Result := true
			if count < a_text.count then
				-- "ab" cannot start with "abc"
				Result := false
			else
				from
					i := 1
				until
					i > a_text.count or not Result
				loop
					Result := item (i) = a_text.code (i)
					i := i + 1
				end
			end
			Result := Result or (count = 0 and a_text.count = 0)
		end

	valid_count (a_count: INTEGER): BOOLEAN
		do
			Result := zero_based_offset + a_count <= text.count
		end

feature -- Duplication

	substring (start_index, end_index: INTEGER): like Current
			-- Shared copy of substring containing all characters at indices
			-- between `start_index' and `end_index'
		require
			valid_indexes: (1 <= start_index) and (start_index <= end_index)
							and (end_index <= count)
 		do
			create Result.make_from_other (Current)
			Result.set_view (zero_based_offset + start_index - 1, end_index - start_index + 1 )
		end

feature -- Status report

	is_empty: BOOLEAN
			--
		do
			Result := count = 0
		end

feature {EL_STRING_VIEW} -- Implementation

	text: READABLE_STRING_GENERAL

	zero_based_offset: INTEGER -- Zero based index

feature {NONE} -- Constant

	new_line_character: NATURAL_32
			--
		once
			Result := ('%N').code.to_natural_32
		end

invariant
	valid_from_index: (0 |..| text.count).has (zero_based_offset)

end
