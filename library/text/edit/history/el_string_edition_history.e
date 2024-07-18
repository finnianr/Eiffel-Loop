note
	description: "String edition_item history"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 17:20:10 GMT (Thursday 18th July 2024)"
	revision: "9"

deferred class
	EL_STRING_EDITION_HISTORY [S -> STRING_GENERAL create make_empty end]

inherit
	ARRAYED_STACK [NATURAL_64]
		rename
			extend as list_extend,
			make as make_array,
			item as edition_item
		redefine
			wipe_out
		end

feature -- Initialization

	make (n: INTEGER)
			--
		do
			make_array (n)
			create redo_stack.make (n)
			create string.make_empty
			create string_list.make (100); string_list.compare_objects
		end

feature -- Access

	caret_position: INTEGER

	string: S

feature -- Element change

	extend (a_string: like string)
		require
			different_from_current: string /~ a_string
		do
			put (new_edition (string, a_string).compact_edition)
			string := a_string
			redo_stack.wipe_out
		end

	redo
		require
			has_redo_items
		do
			restore (redo_stack, Current)
		end

	set_string (a_string: like string)
		do
			string.copy (a_string)
			caret_position := string.count + 1
		end

	undo
		require
			not is_empty
		do
			restore (Current, redo_stack)
		end

feature -- Status query

	has_redo_items: BOOLEAN
		do
			Result := not redo_stack.is_empty
		end

	is_in_default_state: BOOLEAN
		do
			Result := caret_position = 0
		end

feature -- Removal

	wipe_out
		do
			Precursor
			create string.make_empty
			caret_position := 0
			redo_stack.wipe_out
		end

feature {NONE} -- Edition operations

	insert_character (c: CHARACTER_32; start_index: INTEGER)
		deferred
		end

	insert_string (s: like string; start_index: INTEGER)
		deferred
		end

	remove_character (start_index: INTEGER)
		do
			string.remove (start_index)
			caret_position := start_index
		end

	remove_substring (start_index, end_index: INTEGER)
		deferred
		end

	replace_character (c: CHARACTER_32; start_index: INTEGER)
		do
			string.put_code (c.natural_32_code, start_index)
		end

	replace_substring (s: like string; start_index, end_index: INTEGER)
		deferred
		end

feature {NONE} -- Contract Support

	is_edition_valid (a_edition: EL_COMPACTABLE_EDITION; latter, former: like string): BOOLEAN
		local
			l_string: like string; l_caret_position: like caret_position
		do
			l_string := string; l_caret_position := caret_position
			string := latter.twin
			apply_edition (a_edition.compact_edition)
			Result := string ~ former
			string := l_string; caret_position := l_caret_position
		end

feature {NONE} -- Factory

	new_character_32_edition (compact_edition: NATURAL_64): EL_CHARACTER_32_EDITION
		do
			create Result.make_from_compact_edition (compact_edition)
		end

	new_edition (former, latter: like string): EL_COMPACTABLE_EDITION
		require
			are_different: latter /~ former
		local
			shorter, longer: like string; interval: INTEGER_INTERVAL; start_index, end_index: INTEGER
		do
			if latter.count < former.count then
				shorter := latter; longer := former
			else
				shorter := former; longer := latter
			end
			interval := difference_interval (shorter, longer)
			start_index := interval.lower; end_index := interval.upper
			if former.count < latter.count then
				if interval.count = latter.count then
					create {EL_SET_STRING_EDITION} Result.make (Set_string_code, string_list_index (former))

				elseif interval.count = 1 then
					create {EL_REMOVE_TEXT_EDITION} Result.make (Remove_character_code, start_index, 0)
				else
					create {EL_REMOVE_TEXT_EDITION} Result.make (Remove_substring_code, start_index, end_index)
				end
			elseif former.count > latter.count then
				if interval.count = former.count then
					create {EL_SET_STRING_EDITION} Result.make (Set_string_code, string_list_index (former))

				elseif interval.count = 1 then
					create {EL_CHARACTER_32_EDITION} Result.make (Insert_character_code, start_index, former [start_index])
				else
					create {EL_INSERT_STRING_EDITION} Result.make (
						Insert_string_code, string_list_index (former.substring (start_index, end_index)), start_index
					)
				end
			else
				if interval.count = 1 then
					create {EL_CHARACTER_32_EDITION} Result.make (Replace_character_code, start_index, former [start_index])
				else
					create {EL_REPLACE_SUBSTRING_EDITION} Result.make (
						Replace_substring_code, string_list_index (former.substring (start_index, end_index)),
						start_index, end_index
					)
				end
			end
		ensure
			edition_can_revert_latter_to_former: is_edition_valid (Result, latter, former)
		end

	new_insert_string_edition (compact_edition: NATURAL_64): EL_INSERT_STRING_EDITION
		do
			create Result.make_from_compact_edition (compact_edition)
		end

	new_remove_text_edition (compact_edition: NATURAL_64): EL_REMOVE_TEXT_EDITION
		do
			create Result.make_from_compact_edition (compact_edition)
		end

	new_replace_substring_edition (compact_edition: NATURAL_64): EL_REPLACE_SUBSTRING_EDITION
		do
			create Result.make_from_compact_edition (compact_edition)
		end

	new_set_string_edition (compact_edition: NATURAL_64): EL_SET_STRING_EDITION
		do
			create Result.make_from_compact_edition (compact_edition)
		end

feature {NONE} -- Implementation

	apply_edition (compact_edition: NATURAL_64)
		do
			inspect compact_edition |>> 60
				when Insert_character_code then
					if attached new_character_32_edition (compact_edition) as edition then
						insert_character (edition.character, edition.start_index)
					end
				when Insert_string_code then
					if attached new_insert_string_edition (compact_edition) as edition then
						insert_string (string_list [edition.array_index], edition.start_index)
					end
				when Remove_character_code then
					if attached new_remove_text_edition (compact_edition) as edition then
						remove_character (edition.start_index)
					end
				when Remove_substring_code then
					if attached new_remove_text_edition (compact_edition) as edition then
						remove_substring (edition.start_index, edition.end_index)
					end
				when Replace_character_code then
					if attached new_character_32_edition (compact_edition) as edition then
						replace_character (edition.character, edition.start_index)
					end
				when Replace_substring_code then
					if attached new_replace_substring_edition (compact_edition) as edition then
						replace_substring (string_list [edition.array_index], edition.start_index, edition.end_index)
					end
				when Set_string_code then
					if attached new_set_string_edition (compact_edition) as edition then
						set_string (string_list [edition.array_index])
					end
			else
			end
		end

	difference_interval (shorter, longer: like string): INTEGER_INTERVAL
		require
			smaller_and_bigger_different: shorter /~ longer
			smaller_less_than_or_equal_to_bigger: shorter.count <= longer.count
		local
			i, left_i, right_i: INTEGER
			shorter_right_side: like string
		do
			from i := 1 until i > shorter.count or else shorter [i] /= longer [i] loop
				i := i + 1
			end
			left_i := i

			shorter_right_side := shorter.substring (left_i, shorter.count)

			from i := 0 until i > (shorter_right_side.count - 1)
				or else shorter_right_side [shorter_right_side.count - i] /= longer [longer.count - i]
			loop
				i := i + 1
			end
			right_i := longer.count - i
			create Result.make (left_i, right_i)
		end

	restore (edition_stack, counter_edition_stack: ARRAYED_STACK [NATURAL_64])
			-- restore from edition_stack.item and extend counter edition_item to undo
		local
			l_string: S
		do
			l_string := string.twin
			apply_edition (edition_stack.item)
			edition_stack.remove
			counter_edition_stack.extend (new_edition (l_string, string).compact_edition)
		end

	string_list_index (str: like string): INTEGER
		do
			if attached string_list as list then
				list.start
				list.search (str)
				if list.after then
					list.extend (str)
					Result := list.count
				else
					Result := list.index
				end
			end
		end

feature {NONE} -- Internal attributes

	redo_stack: ARRAYED_STACK [NATURAL_64]

	string_list: ARRAYED_LIST [S]

feature -- Edition indices

	Insert_character_code: NATURAL_8 = 1

	Insert_string_code: NATURAL_8 = 2

	Remove_character_code: NATURAL_8 = 3

	Remove_substring_code: NATURAL_8 = 4

	Replace_character_code: NATURAL_8 = 5

	Replace_substring_code: NATURAL_8 = 6

	Set_string_code: NATURAL_8 = 7
end