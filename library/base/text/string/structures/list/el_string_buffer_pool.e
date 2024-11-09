note
	description: "Pool of buffers conforming to ${EL_STRING_BUFFER}"
	notes: "[
		After obtaining a buffer with the call `borrowed_item', make sure to return it
		after use by making the call ${EL_STRING_BUFFER}.return. Failing to do so will
		cause a memory leak.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-08 9:11:25 GMT (Friday 8th November 2024)"
	revision: "2"

class
	EL_STRING_BUFFER_POOL [B -> EL_STRING_BUFFER [STRING_GENERAL, READABLE_STRING_GENERAL] create default_create end]

inherit
	EL_ARRAYED_LIST [B]
		export
			{NONE} all
		redefine
			initialize
		end

create
	make

feature {NONE} -- Initialization

	initialize
		-- initialize default attribute values
		do
			Precursor
			create default_item
		end

feature -- Access

	biggest_item: B
		-- biggest available buffer item (call `return' to release as available item)
		local
			i: INTEGER; i_th_item: B
		do
			if attached area_v2 as l_area then
				Result := default_item
				from i := 0 until i = l_area.count loop
					i_th_item := l_area [i]
					if i_th_item.is_available and then i_th_item.capacity > Result.capacity then
						Result := i_th_item
					end
					i := i + 1
				end
			end
			if Result = default_item then
				create Result
				extend (Result)
			end
			Result.borrow
		end

	borrowed_batch (n: INTEGER): SPECIAL [B]
		-- `n' borrowed items (call `return' to release as available item)
		local
			i: INTEGER; buffer: B
		do
			create Result.make_empty (n)
			if attached area_v2 as l_area then
			-- Try and fill from available buffers
				from i := 0 until Result.valid_index (n - 1) or i = l_area.count loop
					buffer := l_area [i]
					if buffer.is_available then
						Result.extend (buffer)
						buffer.borrow
					end
					i := i + 1
				end
			end
		-- Fill any extra needed
			from until Result.valid_index (n - 1) loop
				Result.extend (create {B})
			end
		ensure
			valid_capacity: Result.count = n
		end

	borrowed_item: B
		-- buffer item marked as borrowed, extending the list if no existing buffers are
		-- are available to borrow. (call `return' on borrowed item when finished using)
		local
			i: INTEGER; l_found: BOOLEAN
		do
			if attached area_v2 as l_area then
				from i := 0 until l_found or i = l_area.count loop
					Result := l_area [i]
					if Result.is_available then
						l_found := True
					else
						i := i + 1
					end
				end
			end
			if not l_found then
				create Result
				extend (Result)
			end
			Result.borrow
		end

	sufficient_item (a_capacity: INTEGER): B
		-- buffer item with sufficient `a_capacity'
		-- (call `return' to release as available item)
		local
			i: INTEGER; i_th_item: B; big_enough: BOOLEAN
		do
			if attached area_v2 as l_area then
				Result := default_item
				from i := 0 until i = l_area.count or big_enough loop
					i_th_item := l_area [i]
					if i_th_item.is_available and then i_th_item.capacity > Result.capacity then
						Result := i_th_item
						big_enough := Result.capacity >= a_capacity
					end
					i := i + 1
				end
			end
			if Result = default_item then
				create Result
				extend (Result)
			end
			if not big_enough then
				Result.resize (a_capacity)
			end
			Result.borrow
		ensure
			big_enough: Result.capacity >= a_capacity
		end

feature -- Basic operations

	return (batch: like borrowed_batch)
		local
			i: INTEGER
		do
			from i := 0 until i = batch.count loop
				batch [i].return
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	default_item: B

end