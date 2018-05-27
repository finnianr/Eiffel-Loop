note
	description: "String view"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "5"

deferred class
	EL_STRING_VIEW

inherit
	EL_STRING_INTERVAL
		rename
			set_offset_and_count as set_view
		export
			{EL_TEXT_PATTERN, EL_PARSER} interval
		redefine
			set_view, set_count
		end

	STRING_HANDLER

convert
	to_string_8: {STRING}, to_string_32: {STRING_32}, to_string_general: {READABLE_STRING_GENERAL},
	to_string: {EL_ZSTRING}

feature {NONE} -- Initialization

	make (a_text: READABLE_STRING_GENERAL)
			-- Copied from {STRING}.share
		do
			full_count :=  a_text.count
			set_full_view
		end

feature -- Access

	absolute_index (i: INTEGER): INTEGER
			-- Absolute index of i
		do
			Result := offset + i
		end

	code (i: INTEGER): NATURAL_32
			-- Character at position `i'
		require
			valid_index: valid_index (i)
		deferred
		end

	code_at_absolute (i: INTEGER): NATURAL_32
			-- Character at position `i'
		require
			valid_index: 1 <= i and i <= full_count
		deferred
		end

	to_string: EL_ZSTRING
		do
			create Result.make_from_general (to_string_general)
		end

	to_string_32: STRING_32
			--
		do
			Result := to_string_general.as_string_32
		end

	to_string_8: STRING
			--
		do
			Result := to_string_general.as_string_8
		end

	to_string_general: READABLE_STRING_GENERAL
		deferred
		end

	interval_string (a_interval: like interval): like to_string
			-- Returns ZSTRING represented by substring interval
		local
			l_interval: like interval
		do
			l_interval := interval
			set_interval (a_interval)
			Result := to_string
			set_interval (l_interval)
		end

	interval_string_8 (a_interval: like interval): like to_string_8
			-- Returns STRING_8 represented by substring interval
		local
			l_interval: like interval
		do
			l_interval := interval
			set_interval (a_interval)
			Result := to_string_8
			set_interval (l_interval)
		end

	interval_string_32 (a_interval: like interval): like to_string_32
			-- Returns STRING_32 represented by substring interval
		local
			l_interval: like interval
		do
			l_interval := interval
			set_interval (a_interval)
			Result := to_string_32
			set_interval (l_interval)
		end

feature -- Measurement

	full_count: INTEGER

	occurrences (c: like code): INTEGER
		deferred
		end

feature -- Element Change

	set_count (a_count: INTEGER)
			--
		require else
			valid_count: valid_count (a_count)
		do
			Precursor (a_count)
		end

	set_full_view
			-- Restore to full size of shared string
		do
			set_view (0, full_count)
		end

	set_view (a_from_index, a_count: INTEGER)
			--
		require else
			valid_index: a_from_index <= full_count
			valid_count: a_count <= (full_count - a_from_index)
		do
			Precursor (a_from_index, a_count)
		end

feature -- Removal

	prune_leading (count_to_remove: INTEGER)
			--
		require
			are_characters_to_remove: count_to_remove <= count
		do
			set_view (offset + count_to_remove, count - count_to_remove)
		ensure
			valid_from_index: offset <= full_count
		end

feature -- Status query

	is_empty: BOOLEAN
			--
		do
			Result := count = 0
		end

	is_start_of_line: BOOLEAN
			--
		do
			if offset = 0 then
				Result := true
			else
				Result := code_at_absolute (offset) = 10
			end
		end

	starts_with (a_text: READABLE_STRING_GENERAL): BOOLEAN
			--
		local
			i, text_count: INTEGER
		do
			Result := true
			text_count := a_text.count
			if count < text_count then
				-- "ab" cannot start with "abc"
				Result := false
			else
				from i := 1 until i > text_count or not Result loop
					Result := code (i) = a_text.code (i)
					i := i + 1
				end
			end
			Result := Result or (count = 0 and a_text.count = 0)
		end

	starts_with_interval (a_interval: EL_STRING_INTERVAL): BOOLEAN
			-- True if relative interval starts with absolute interval in the same string
			-- Used for back reference matching
		local
			i, l_count, l_offset: INTEGER
		do
			l_count := a_interval.count; l_offset := a_interval.offset
			if count >= l_count then
				Result := True
				from i := 1 until not Result or else i > l_count loop
					Result := Result and code_at_absolute (l_offset + i) = code (i)
					i := i + 1
				end
			end
		end

	valid_count (a_count: INTEGER): BOOLEAN
		do
			Result := offset + a_count <= full_count
		end

	valid_index (index: INTEGER): BOOLEAN
		do
			Result := index >= 1 and then index <= count
		end

feature -- Duplication

	substring (start_index, end_index: INTEGER): like Current
			-- Shared copy of substring containing all characters at indices
			-- between `start_index' and `end_index'
		require
			valid_indexes: (1 <= start_index) and (start_index <= end_index)
							and (end_index <= count)
 		do
			Result := twin
			Result.set_view (offset + start_index - 1, end_index - start_index + 1 )
		end

invariant
	valid_from_index: (0 |..| full_count).has (offset)

end
