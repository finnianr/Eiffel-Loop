note
	description: "[
		Map character capacities to reuseable buffer strings. A negative count indicates that the string item
		is "on loan" as a buffer. A positive count indicates the string is available to borrow.
		
		The `borrowed_item' routine returns the best match for a preferred capacity.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 18:06:55 GMT (Wednesday 8th November 2023)"
	revision: "2"

class
	EL_STRING_POOL [S -> STRING_GENERAL create make end]

inherit
	EL_ARRAYED_MAP_LIST [INTEGER, S]
		rename
			area_v2 as capacity_area
		export
			{NONE} all
			{ANY} count, is_empty, valid_index
		end

create
	make

feature -- Access

	borrowed_item (preferred_capacity: INTEGER): S
		-- returns string with biggest capacity if `preferred_capacity = 0'
		-- else returns the item that is closest in capacity to `preferred_capacity'
		-- if no item is available create a new item
		local
			i, match_index, match_size, string_capacity: INTEGER
		do
			if attached capacity_area as size then
				match_index := (1).opposite

				from i := 0 until i = size.count loop
					string_capacity := size [i]
					if string_capacity > 0 then -- is available
						if preferred_capacity > 0 and then string_capacity >= preferred_capacity
							and then match_size >= preferred_capacity
						then
						-- check if this item is closer to `preferred_capacity'
							if (string_capacity - preferred_capacity) < (match_size - preferred_capacity) then
								match_size := string_capacity; match_index := i
							end

						elseif string_capacity > match_size then
							match_size := string_capacity; match_index := i
						end
					end
					i := i + 1
				end
				if match_index < 0 then
					if preferred_capacity > 0 then
						create Result.make (preferred_capacity.max (1))
					else
						create Result.make (1)
					end
					match_index := area.count; match_size := Result.capacity
					extend (match_size.opposite, Result)
				else
					size [match_index] := match_size.opposite
					check
						negative: size [match_index] < 0
					end
				end
			end
			Result := internal_value_list.area_v2 [match_index]
			last_index := match_index + 1
			Result.keep_head (0)
		ensure
			new_item_added: old available_count = 0 implies Result = internal_value_list.last
			empty_item: Result.is_empty
		end

	last_index: INTEGER

feature -- Measurement

	available_count: INTEGER
		local
			i: INTEGER
		do
			if attached capacity_area as string_capacity then
				from i := 0 until i = string_capacity.count loop
					if string_capacity [i] > 0 then
						Result := Result + 1
					end
					i := i + 1
				end
			end
		end

	loaned_count: INTEGER
		do
			Result := count - available_count
		end

feature -- Element change

	free (loan_index: INTEGER)
		require
			valid_index: valid_index (loan_index)
		do
			put_i_th (internal_value_list [loan_index].capacity, loan_index)
		end

	free_list (loan_indices: ARRAYED_LIST [INTEGER])
		-- free all borrowed strings with index in `loan_indices' and
		-- wipeout `loan_indices'
		require
			enough_loaned: loaned_count >= loan_indices.count
			valid_indices: loan_indices.for_all (agent valid_index)
		local
			i, loan_index: INTEGER
		do
			if attached loan_indices.area as l_area
				and then attached area as string_capacity
				and then attached internal_value_list.area as item_string
			then
				from i := 0 until i = l_area.count loop
					loan_index := l_area [i] - 1
					string_capacity [loan_index] := item_string [loan_index].capacity
					i := i + 1
				end
			end
			loan_indices.wipe_out
		ensure
			availability_increased: available_count = old available_count + old loan_indices.count
		end

	return (str: S)
		local
			i: INTEGER; found_value: BOOLEAN
		do
			if attached internal_value_list.area_v2 as value then
				from i := 0 until found_value or else i = value.count loop
					if value [i] /= str then
						i := i + 1
					else
						found_value := True
					end
				end
				if found_value then
					capacity_area [i] := str.capacity -- make available
				end
			end
		ensure
			availability_plus_one: available_count = old available_count + 1
		end

end