note
	description: "Integer point"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_INTEGER_POINT

inherit
	ARRAY [INTEGER]
		rename
			make as make_from_to
		end
	
	HASHABLE
		undefine
			is_equal, copy
		end

create
	make, make_x_y
	
feature {NONE} -- Initialization

	make
			-- 
		do
			make_from_to (1, 2)
		end

	make_x_y (x, y: INTEGER)
			-- 
		do
			make
			put (x, 1)
			put (y, 2)
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		local
			combined_x_y: INTEGER_64
		do
			combined_x_y := item (1) 
			combined_x_y := combined_x_y |<< 32
			combined_x_y := combined_x_y | item (2)
			Result := combined_x_y.hash_code
		end

end