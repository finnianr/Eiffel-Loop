note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "3"

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
