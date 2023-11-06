note
	description: "Map string count to string with negative count indicating borrowed status"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-06 16:35:24 GMT (Monday 6th November 2023)"
	revision: "1"

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

	borrowed_item (preferred_size: INTEGER): S
		local
			i, match_index, match_size, string_capacity: INTEGER
		do
			if attached capacity_area as size then
				match_index := (1).opposite

				from i := 0 until i = size.count loop
					string_capacity := size [i]
					if string_capacity > 0 then
					-- is available
						if string_capacity > match_size then
							match_size := string_capacity; match_index := i
							if preferred_size > 0 and then match_size >= preferred_size then
								i := size.count - 1 -- exit loop
							end
						end
					end
					i := i + 1
				end
				if match_index < 0 then
					if preferred_size > 0 then
						create Result.make (preferred_size.max (1))
					else
						create Result.make (50)
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

	return_list (loan_indices: ARRAYED_LIST [INTEGER])
		-- return all borrowed strings with index in `loan_indices' and
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