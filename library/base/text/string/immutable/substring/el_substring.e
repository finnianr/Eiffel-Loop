note
	description: "[
		Substring text item of a shared UTF-8 encoded table manifest formatted as colon delimited keys
		as for example:

			key_1:
				line 1..
				line 2..
			key_2:
				line 1..
				line 2..
			..

	]"
	notes: "[
		Used to implement class ${EL_REFLECTIVE_STRING_TABLE}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-03 10:10:03 GMT (Saturday 3rd August 2024)"
	revision: "3"

deferred class
	EL_SUBSTRING [S -> STRING_GENERAL create make end]

inherit
	ANY

	EL_READABLE_STRING_GENERAL_ROUTINES_IMP
		export
			{NONE} all
		end

	EL_STRING_BIT_COUNTABLE [S]

feature {NONE} -- Initialization

	make_empty
		do
			utf_8_manifest := Empty_text
		end

feature -- Element change

	make, set_string (a_utf_8_manifest: IMMUTABLE_STRING_8; a_start_index, a_end_index: INTEGER)
		do
			utf_8_manifest := a_utf_8_manifest; start_index := a_start_index; end_index := a_end_index
		end

feature -- Access

	count: INTEGER
		-- count of characters omitting leading tab
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			Result := utf_8.unicode_substring_count (utf_8_manifest, start_index + 1, end_index)
			if attached shared_cursor_8 (utf_8_manifest) as cursor then
			-- subtract count of leading tabs by counting lines
				Result := Result - cursor.occurrences_in_bounds ('%N', start_index + 1, end_index)
			end
		end

	lines: EL_STRING_LIST [S]
		do
			create Result.make_with_lines (string)
		end

	string, str: S
		-- substring of `utf_8_manifest' defined by `start_index' and `end_index'
		do
			Result := string_x.new_from_utf_8_lines (utf_8_manifest, start_index, end_index)
		ensure
			valid_count: Result.count = count
		end

feature {NONE} -- Implementation

	string_x: EL_STRING_X_ROUTINES [S, READABLE_STRING_GENERAL, COMPARABLE]
		deferred
		end

feature {NONE} -- Internal attributes

	end_index: INTEGER

	start_index: INTEGER

	utf_8_manifest: IMMUTABLE_STRING_8
		-- shared manifest string with format

		-- 	key_1:
		--			line 1..
		--			line 2..
		-- 	key_2:
		--			line 1..
		--			line 2..
		--		..

feature {NONE} -- Constants

	Empty_text: IMMUTABLE_STRING_8
		once
			create Result.make_empty
		end
end