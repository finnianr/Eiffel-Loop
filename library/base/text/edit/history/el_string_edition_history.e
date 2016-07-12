note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-21 22:14:10 GMT (Sunday 21st December 2014)"
	revision: "4"

deferred class
	EL_STRING_EDITION_HISTORY [S -> STRING_GENERAL create make_empty end]

inherit
	ARRAYED_STACK [TUPLE [index: INTEGER_8; arguments: TUPLE]]
		rename
			extend as list_extend,
			make as make_array,
			item as edition
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
			string := a_string
			caret_position := string.count + 1
		end

	extend (a_string: like string)
		require
			different_from_current: string /~ a_string
		do
			list_extend (new_edition (string, a_string))
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

	is_edition_valid (a_edition: like edition; latter, former: like string): BOOLEAN
		local
			l_string: like string; l_caret_position: like caret_position
		do
			l_string := string; l_caret_position := caret_position
			string := latter.twin
			apply (a_edition)
			Result := string ~ former
			string := l_string; caret_position := l_caret_position
		end

feature {NONE} -- Factory

	new_edition (former, latter: like string): like edition
		require
			are_different: latter /~ former
		local
			shorter, longer: like string
			interval: INTEGER_INTERVAL; start_index, end_index: INTEGER
			edition_index: INTEGER_8
			arguments: TUPLE
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
					edition_index := Edition_set_string; arguments := [former]

				elseif interval.count = 1 then
					edition_index := Edition_remove_character; arguments := [start_index]
				else
					edition_index := Edition_remove_substring; arguments := [start_index, end_index]
				end
			elseif former.count > latter.count  then
				if interval.count = former.count then
					edition_index := Edition_set_string; arguments := [former]

				elseif interval.count = 1 then
					edition_index := Edition_insert_character; arguments := [former [start_index], start_index]
				else
					edition_index := Edition_insert_string; arguments := [former.substring (start_index, end_index), start_index]
				end
			else
				if interval.count = 1 then
					edition_index := Edition_replace_character; arguments := [former [start_index], start_index]
				else
					edition_index := Edition_replace_substring
					arguments := [former.substring (start_index, end_index), start_index, end_index]
				end
			end
			Result := [edition_index, arguments]
		ensure
			edition_can_revert_latter_to_former: is_edition_valid (Result, latter, former)
		end

	new_edition_procedures: ARRAY [PROCEDURE [EL_STRING_EDITION_HISTORY [STRING_GENERAL], TUPLE]]
		do
			create Result.make_filled (agent do_nothing, 1, Edition_upper)

			Result [Edition_insert_character] := agent insert_character
			Result [Edition_insert_string] := agent insert_string
			Result [Edition_remove_character] := agent remove_character
			Result [Edition_remove_substring] := agent remove_substring
			Result [Edition_replace_character] := agent replace_character
			Result [Edition_replace_substring] := agent replace_substring
			Result [Edition_set_string] := agent set_string
		end

feature {NONE} -- Implementation

	apply (a_edition: like edition)
		do
			edition_procedures.item (a_edition.index).call (a_edition.arguments)
		end

	restore (edition_stack, counter_edition_stack: ARRAYED_STACK [like edition])
			-- restore from edition_stack.item and extend counter edition to undo
		local
			l_string: S
		do
			l_string := string.twin
			apply (edition_stack.item)
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

	redo_stack: ARRAYED_STACK [like edition]

	edition_procedures: like new_edition_procedures

feature {NONE} -- Constants

	Edition_insert_character: INTEGER_8 = 1

	Edition_insert_string: INTEGER_8 = 2

	Edition_remove_character: INTEGER_8 = 3

	Edition_remove_substring: INTEGER_8 = 4

	Edition_replace_character: INTEGER_8 = 5

	Edition_replace_substring: INTEGER_8 = 6

	Edition_set_string, Edition_upper: INTEGER_8 = 7

end
