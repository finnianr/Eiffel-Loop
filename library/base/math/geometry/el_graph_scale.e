note
	description: "Graph scale"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:03 GMT (Saturday 19th May 2018)"
	revision: "3"

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
