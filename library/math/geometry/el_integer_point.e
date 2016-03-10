note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

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
