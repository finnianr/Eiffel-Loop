note
	description: "Iteration cursor for [$source ITERABLE_COMPLEX_DOUBLE_VECTOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 8:02:01 GMT (Monday 20th January 2020)"
	revision: "2"

class
	VECTOR_COMPLEX_DOUBLE_ITERATION_CURSOR

inherit
	ITERATION_CURSOR [COMPLEX_DOUBLE]

create
	make

feature {NONE} -- Initialization

	make (vector: VECTOR_COMPLEX_DOUBLE)
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

	item: COMPLEX_DOUBLE
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

	internal_item: COMPLEX_DOUBLE

end
