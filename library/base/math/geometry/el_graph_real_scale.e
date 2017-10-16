note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_GRAPH_REAL_SCALE

create
	make
	
feature {NONE} -- Initialization

	make (a_lower_bound, a_upper_bound: REAL)
			-- 
		do
			lower_bound := a_lower_bound
			upper_bound := a_upper_bound
			length := upper_bound - lower_bound
			set_position (lower_bound)
		end

feature -- Element change

	set_position (value: REAL)
			--
		require
			valid_position: value >= lower_bound and value <= upper_bound
		do
			position := value 
			relative_position := (position - lower_bound) / length
		end

	set_relative_position (proportion: REAL)
			-- 
		do
			
		end
		
feature -- Access

	relative_position: REAL 

	position: REAL

	lower_bound, upper_bound: REAL 
	
	length: REAL
	
end