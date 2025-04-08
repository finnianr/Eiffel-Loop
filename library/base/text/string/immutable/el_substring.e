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
	date: "2025-04-08 12:10:27 GMT (Tuesday 8th April 2025)"
	revision: "9"

deferred class
	EL_SUBSTRING [S -> STRING_GENERAL create make end]

inherit
	EL_MAKEABLE
		rename
			make as make_empty
		end

	EL_READABLE_STRING_GENERAL_ROUTINES_I
		export
			{NONE} all
		end

	EL_STRING_GENERAL_ROUTINES_I

	EL_STRING_BIT_COUNTABLE [S]

feature {NONE} -- Initialization

	make_empty
		do
			utf_8_manifest := Empty_text
		end

feature -- Element change

	make, set_string (a_utf_8_manifest: IMMUTABLE_STRING_8; a_start_index, a_end_index: INTEGER)
		require
			valid_start_index: a_utf_8_manifest.count > 0 implies a_utf_8_manifest.valid_index (a_start_index)
			valid_end_index: a_end_index >= a_start_index implies a_utf_8_manifest.valid_index (a_end_index)
		do
			utf_8_manifest := a_utf_8_manifest; start_index := a_start_index; end_index := a_end_index
		end

	wipe_out
		do
			make_empty
		end

feature -- Access

	count: INTEGER
		-- count of characters omitting leading tab
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			Result := utf_8.unicode_substring_count (utf_8_manifest, start_index + 1, end_index)
			if attached super_readable_8 (utf_8_manifest) as super then
			-- subtract count of leading tabs by counting lines
				Result := Result - super.occurrences_in_bounds ('%N', start_index + 1, end_index)
			end
		end

	lines: EL_STRING_LIST [S]
		do
			create Result.make_with_lines (string)
		end

	string, str: S
		-- substring of `utf_8_manifest' defined by `start_index' and `end_index'
		do
			Result := string_x.new_from_immutable_8 (utf_8_manifest, start_index, end_index, True, True)
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