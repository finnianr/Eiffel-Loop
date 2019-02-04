note
	description: "String edition_item history"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "5"

deferred class
	EL_STRING_EDITION_HISTORY [S -> STRING_GENERAL create make_empty end]

inherit
	ARRAYED_STACK [EL_STRING_EDITION]
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
			edition_procedures := new_edition_procedures
		end

feature -- Access

	string: S

	caret_position: INTEGER

feature -- Element change

	set_string (a_string: like string)
		do
			string.copy (a_string)
			caret_position := string.count + 1
		end

	extend (a_string: like string)
		require
			different_from_current: string /~ a_string
		do
			put (new_edition (string, a_string))
			string := a_string
			redo_stack.wipe_out
		end

	undo
		require
			not is_empty
		do
			restore (Current, redo_stack)
		end

	redo
		require
			has_redo_items
		do
			restore (redo_stack, Current)
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

	is_edition_valid (a_edition: EL_STRING_EDITION; latter, former: like string): BOOLEAN
		local
			l_string: like string; l_caret_position: like caret_position
		do
			l_string := string; l_caret_position := caret_position
			string := latter.twin
			a_edition.apply (edition_procedures)
			Result := string ~ former
			string := l_string; caret_position := l_caret_position
		end

feature {NONE} -- Factory

	new_edition (former, latter: like string): EL_STRING_EDITION
		require
			are_different: latter /~ former
		local
			shorter, longer: like string
			interval: INTEGER_INTERVAL; start_index, end_index: INTEGER
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
					create Result.make (Edition.set_string, [former])

				elseif interval.count = 1 then
					create Result.make (Edition.remove_character, [start_index])
				else
					create Result.make (Edition.remove_substring, [start_index, end_index])
				end
			elseif former.count > latter.count  then
				if interval.count = former.count then
					create Result.make (Edition.set_string, [former])

				elseif interval.count = 1 then
					create Result.make (Edition.insert_character, [former [start_index], start_index])
				else
					create Result.make (Edition.insert_string, [former.substring (start_index, end_index), start_index])
				end
			else
				if interval.count = 1 then
					create Result.make (Edition.replace_character, [former [start_index], start_index])
				else
					create Result.make (
						Edition.replace_substring, [former.substring (start_index, end_index), start_index, end_index]
					)
				end
			end
		ensure
			edition_can_revert_latter_to_former: is_edition_valid (Result, latter, former)
		end

	new_edition_procedures: ARRAY [PROCEDURE]
		do
			create Result.make_filled (agent do_nothing, 1, Edition.upper)

			Result [Edition.insert_character] := agent insert_character
			Result [Edition.insert_string] := agent insert_string
			Result [Edition.remove_character] := agent remove_character
			Result [Edition.remove_substring] := agent remove_substring
			Result [Edition.replace_character] := agent replace_character
			Result [Edition.replace_substring] := agent replace_substring
			Result [Edition.set_string] := agent set_string
		end

feature {NONE} -- Implementation

	restore (edition_stack, counter_edition_stack: ARRAYED_STACK [EL_STRING_EDITION])
			-- restore from edition_stack.item and extend counter edition_item to undo
		local
			l_string: S
		do
			l_string := string.twin
			edition_stack.item.apply (edition_procedures)
			edition_stack.remove
			counter_edition_stack.extend (new_edition (l_string, string))
		end

	difference_interval (shorter, longer: like string): INTEGER_INTERVAL
		require
			smaller_and_bigger_different: shorter /~ longer
			smaller_less_than_or_equal_to_bigger: shorter.count <= longer.count
		local
			i, left_i, right_i: INTEGER
			shorter_right_side: like string
		do
			from i := 1 until
				i > shorter.count or else shorter [i] /= longer [i]
			loop
				i := i + 1
			end
			left_i := i

			shorter_right_side := shorter.substring (left_i, shorter.count)

			from i := 0 until
				i > (shorter_right_side.count - 1)
					or else shorter_right_side [shorter_right_side.count - i] /= longer [longer.count - i]
			loop
				i := i + 1
			end
			right_i := longer.count - i
			create Result.make (left_i, right_i)
		end

	redo_stack: ARRAYED_STACK [EL_STRING_EDITION]

	edition_procedures: like new_edition_procedures

feature {NONE} -- Constants

	Edition: EL_STRING_EDITION
		once
			create Result.make (0, [])
		end

end
