note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

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
