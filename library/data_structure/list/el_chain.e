note
	description: "Summary description for {EL_LINEAR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-12 15:15:21 GMT (Wednesday 12th June 2013)"
	revision: "2"

deferred class EL_CHAIN [G]

inherit
	CHAIN [G]

	EL_LINEAR [G]
		undefine
			search, has, index_of, occurrences, off
		end

feature -- Access

	search_results (value: ANY; value_function: FUNCTION [G, TUPLE, ANY]): ARRAYED_LIST [G]
		require
			valid_open_count: value_function.open_count = 1
			valid_value_function: not is_empty implies value_function.empty_operands.valid_type_for_index (first, 1)
		local
			pos: CURSOR
		do
			pos := cursor
			create Result.make ((count // 4).max (20))
			from start_find until after loop
				find_next (value, value_function)
				if not after then
					Result.extend (item)
				end
			end
			go_to (pos)
		end

	string_array (string_function: FUNCTION [G, TUPLE, EL_ASTRING]): ARRAY [EL_ASTRING]
			-- collected results of call to string function on all items
		require
			valid_open_count: string_function.open_count = 1
			valid_value_function: not is_empty implies string_function.empty_operands.valid_type_for_index (first, 1)
		local
			pos: CURSOR
		do
			pos := cursor
			create Result.make (1, count)
			from start until after loop
				Result [index] := string_function.item ([item])
				forth
			end
			go_to (pos)
		end

	subchain (index_from, index_to: INTEGER ): EL_CHAIN [G]
		require
			valid_indices: (1 <= index_from) and (index_from <= index_to) and (index_to <= count)
		local
			i: INTEGER; pos: CURSOR
		do
			pos := cursor
			create {EL_ARRAYED_LIST [G]} Result.make (index_to - index_from + 1)
			go_i_th (index_from)
			from i := index_from until i > index_to loop
				Result.extend (item)
				forth
				i := i + 1
			end
			go_to (pos)
		end

feature -- Removal

	remove_last
		do
			finish; remove
		end

end
