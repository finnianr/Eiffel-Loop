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
	date: "2024-08-03 15:58:54 GMT (Saturday 3rd August 2024)"
	revision: "5"

deferred class
	EL_SUBSTRING [S -> STRING_GENERAL create make end]

inherit
	EL_MAKEABLE
		rename
			make as make_empty
		end

	EL_READABLE_STRING_GENERAL_ROUTINES_IMP
		export
			{NONE} all
		end

	EL_STRING_BIT_COUNTABLE [S]

	EL_SHARED_IMMUTABLE_8_MANAGER

feature {NONE} -- Initialization

	make_empty
		do
			utf_8_area := Empty_area
		end

feature -- Element change

	make, set_area (a_utf_8_area: like utf_8_area; a_start_index, a_end_index: INTEGER)
		require
			valid_start_index: a_utf_8_area.valid_index (a_start_index)
			valid_end_index: a_end_index >= a_start_index implies a_utf_8_area.valid_index (a_end_index)
		do
			utf_8_area := a_utf_8_area; start_index := a_start_index; end_index := a_end_index
		end

feature -- Access

	count: INTEGER
		-- count of characters omitting leading tab
		local
			utf_8: EL_UTF_8_CONVERTER; i: INTEGER
		do
			if attached utf_8_area as area then
				Result := utf_8.array_unicode_count (area, start_index + 1, end_index)
			-- subtract count of leading tabs by counting lines
				from i := start_index + 1 until i > end_index loop
					inspect area [i]
						when '%N' then
							Result := Result - 1
					else
					end
					i := i + 1
				end
			end
		end

	lines: EL_STRING_LIST [S]
		do
			create Result.make_with_lines (string)
		end

	string, str: S
		-- substring of `utf_8_manifest' defined by `start_index' and `end_index'
		do
			Immutable_8.set_item (utf_8_area, start_index + 1, end_index - start_index)
			Result := string_x.new_unindented_utf_8 (Immutable_8.item)
		ensure
			valid_count: Result.count = count
		end

feature {NONE} -- Implementation

	string_x: EL_STRING_X_ROUTINES [S, READABLE_STRING_GENERAL, COMPARABLE]
		deferred
		end

feature {NONE} -- Internal attributes

	end_index: INTEGER
		-- zero based index into `utf_8_area'

	start_index: INTEGER
		-- zero based index into `utf_8_area'

	utf_8_area: SPECIAL [CHARACTER]
		-- shared manifest area with format

		-- 	key_1:
		--			line 1..
		--			line 2..
		-- 	key_2:
		--			line 1..
		--			line 2..
		--		..

feature {NONE} -- Constants

	Empty_area: SPECIAL [CHARACTER]
		once
			create Result.make_empty (0)
		end
end