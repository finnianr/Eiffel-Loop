note
	description: "Abstraction for indexing a data array with"
	description: "Abstraction for indexing a data array with"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 17:20:39 GMT (Thursday 17th April 2025)"
	revision: "2"

deferred class
	EL_MODULO_INDEXABLE

feature -- Measurement

	count: INTEGER
		deferred
		end

feature -- Status query

	valid_slice (start_index, end_index: INTEGER): BOOLEAN
		local
			end_i: INTEGER
		do
			end_i := modulo_index (end_index)
			Result := end_i < count and then modulo_index (start_index) - 1 <= end_i
		end

feature {NONE} -- Implementation

	modulo_index (i: INTEGER): INTEGER
		do
			Result := i \\ count
			if Result < 0 then
				Result := count + i
			end
		end

end