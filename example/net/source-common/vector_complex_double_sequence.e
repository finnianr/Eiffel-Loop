note
	description: "Summary description for {VECTOR_COMPLEX_DOUBLE_SEQUENCE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:06 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	VECTOR_COMPLEX_DOUBLE_SEQUENCE

inherit
	LIST [E2X_COMPLEX_DOUBLE]
		export
			{NONE} all
			{ANY} before, after, off, writable, readable
		redefine
			item
		end

create
	make_from_vector

feature {NONE} -- Initialization

	make_from_vector (vector: VECTOR_COMPLEX_DOUBLE)
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

	item: E2X_COMPLEX_DOUBLE
			-- Current item
      local
         i: INTEGER
      do
         i := 2 * index - 2
         internal_item.set (component_area.item (i), component_area.item (i + 1) )
         Result := internal_item
      end

	count: INTEGER

	index: INTEGER

feature -- Basic operations

	forth
			--
		do
			index := index + 1
		end

	back
			--
		do
			index := index - 1
		end

feature {NONE} -- Unused

	replace (v: E2X_COMPLEX_DOUBLE)
			--
		do
		end

	extend (v: E2X_COMPLEX_DOUBLE)
			--
		do
		end

	duplicate (n: INTEGER): like Current
			--
		do
		end

	cursor: CURSOR
			--
		do
		end

	valid_cursor (p: CURSOR): BOOLEAN
			--
		do
		end

	go_to (p: CURSOR)
			--
		do
		end

	prunable: BOOLEAN = false

	extendible: BOOLEAN = false

	full: BOOLEAN = false

	wipe_out
			--
		do
		end

feature {NONE} -- Implementation

	internal_item: E2X_COMPLEX_DOUBLE

	component_area: SPECIAL [DOUBLE]

end
