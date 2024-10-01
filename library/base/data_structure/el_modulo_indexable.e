note
	description: "Abstraction for indexing a data array with"
	description: "Abstraction for indexing a data array with"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-01 12:27:10 GMT (Tuesday 1st October 2024)"
	revision: "1"

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