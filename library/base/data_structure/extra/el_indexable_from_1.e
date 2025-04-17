note
	description: "Abstraction for a container that is indexable in the range 1 to `count'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 17:20:48 GMT (Thursday 17th April 2025)"
	revision: "2"

deferred class
	EL_INDEXABLE_FROM_1

inherit
	ANY
		undefine
			default_create, copy, is_equal, out
		end

feature -- Measurement

	count: INTEGER
		deferred
		end

feature -- Status query

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' a valid index?
		deferred
		end

	valid_indices_range (start_index, end_index: INTEGER): BOOLEAN
		do
			inspect count
				when 0 then
					Result := start_index = 1 and end_index = 0
			else
				if valid_index (start_index) then
					Result := end_index >= start_index - 1 and end_index <= count
				end
			end
		end

end