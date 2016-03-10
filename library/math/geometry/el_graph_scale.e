note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_GRAPH_SCALE
	
inherit
	INTEGER_INTERVAL
		redefine
			make
		end

create
	make_from_interval, make
	
feature {NONE} -- Initialization

	make_from_interval (bounds: INTEGER_INTERVAL)
			--
		do
			make (bounds.lower, bounds.upper)
		end
	
	make (min_value, max_value: INTEGER)
			-- 
		do
			Precursor (min_value, max_value)
			length := upper - lower
		end

feature -- Element change

	set_position (a_position: INTEGER)
			--
		do
			position := a_position
			
			-- Correct values that fall out side scale boundaries
			if position > upper then
				position := upper	
			
			elseif position < lower then
				position := lower
			end
			
		end

feature -- Access

	relative_position: REAL
			--
		do
			Result := (position - lower) / length;
		end

	position: INTEGER

	length: REAL
	
end

