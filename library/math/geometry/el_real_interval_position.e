note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_REAL_INTERVAL_POSITION

inherit
	EL_INTERVAL_POSITION [REAL]
		undefine
			is_equal, out
		redefine
			item
		end
		
	REAL_REF

create
	make

feature -- Status report

	is_A_less_than_or_equal_to_B (a, b: like item): BOOLEAN
			-- 
		do
			Result := a <= b			
		end

end
