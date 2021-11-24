note
	description: "[
		Iteration cursor for descendants of [$source VECTOR_COMPLEX_64]

			VECTOR_COMPLEX_64*
				[$source COLUMN_VECTOR_COMPLEX_64]
				[$source ROW_VECTOR_COMPLEX_64]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-24 10:37:21 GMT (Wednesday 24th November 2021)"
	revision: "4"

class
	VECTOR_COMPLEX_64_ITERATION_CURSOR

inherit
	ITERATION_CURSOR [COMPLEX_64]

create
	make

feature {NONE} -- Initialization

	make (vector: VECTOR_COMPLEX_64)
			--
		do
			index := 1
			create internal_item.make
			if vector.is_column_vector then
				count := vector.height
			else
				count := vector.width
			end
			component_area := vector.area
		end

feature -- Access

	count: INTEGER

	index: INTEGER

	item: COMPLEX_64
			-- Current item
      local
         i: INTEGER
      do
         i := 2 * index - 2
         internal_item.set (component_area.item (i), component_area.item (i + 1) )
         Result := internal_item
      end

feature -- Basic operations

	forth
			--
		do
			index := index + 1
		end

feature -- Status query

	after: BOOLEAN
		do
			Result := index > count
		end

feature {NONE} -- Implementation

	component_area: SPECIAL [DOUBLE]

	internal_item: COMPLEX_64

end