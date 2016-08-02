note
	description: "Summary description for {EL_LINEAR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:04:12 GMT (Wednesday 16th December 2015)"
	revision: "1"

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
			position: CURSOR
		do
			position := cursor
			create Result.make ((count // 10).max (20)) -- 10% or 20 which ever is bigger
			from find_first (value, value_function) until after loop
				Result.extend (item)
				find_next (value, value_function)
			end
			go_to (position)
		end

	string_list (string_function: FUNCTION [G, TUPLE, ZSTRING]): EL_ZSTRING_LIST
			-- collected results of call to string function on all items
		require
			valid_open_count: string_function.open_count = 1
			valid_value_function: not is_empty implies string_function.empty_operands.valid_type_for_index (first, 1)
		local
			position: CURSOR
		do
			position := cursor
			create Result.make (count)
			from start until after loop
				Result.extend (string_function.item ([item]))
				forth
			end
			go_to (position)
		end

	subchain (index_from, index_to: INTEGER ): EL_CHAIN [G]
		require
			valid_indices: (1 <= index_from) and (index_from <= index_to) and (index_to <= count)
		local
			i: INTEGER; position: CURSOR
		do
			position := cursor
			create {EL_ARRAYED_LIST [G]} Result.make (index_to - index_from + 1)
			go_i_th (index_from)
			from i := index_from until i > index_to loop
				Result.extend (item)
				forth
				i := i + 1
			end
			go_to (position)
		end

	index_for_value (value: ANY; value_function: FUNCTION [G, TUPLE, ANY]): INTEGER
			-- index of item with function returning result equal to value, 0 if not found
		local
			position: CURSOR
		do
			position := cursor
			find_first (value, value_function)
			if found then
				Result := index
			end
			go_to (position)
		end

feature -- Removal

	remove_last
		do
			finish; remove
		end

end