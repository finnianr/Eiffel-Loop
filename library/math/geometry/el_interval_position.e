note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_INTERVAL_POSITION [N -> NUMERIC]

feature -- Initialization

	make (a_lower_bound, a_upper_bound: like item)
			-- 
		require
			lower_less_than_or_equal_to_upper: is_A_less_than_or_equal_to_B (a_lower_bound, a_upper_bound)
		do
			lower_bound := a_lower_bound
			upper_bound := a_upper_bound
		end

feature -- Access

	lower_bound, upper_bound: like item
	
	item: N
			-- 
		deferred
		end

feature -- Measurement

	proportion: like item
			-- 
		do
			Result := (item - lower_bound) / length
		end

	length: like item
			-- 
		do
			Result := upper_bound - lower_bound
		end
	
	value_as_proportion (value: like item): like item
			-- 
		do
			Result := (value - lower_bound) / length
		end
	
feature -- Element change

	set_proportion (a_proportion: like item)
			-- Set `proportion' to `a_proportion'.
		require
			valid_proportion: 
				is_A_less_than_or_equal_to_B (item.zero, a_proportion)
					and then is_A_less_than_or_equal_to_B (a_proportion, item.one)
		do
			set_item (lower_bound + (a_proportion * length))
		end

	set_item (v: like item)
			-- 
		require
			valid_value: 
				is_A_less_than_or_equal_to_B (lower_bound, v) and is_A_less_than_or_equal_to_B (v, upper_bound)
		deferred
		end
		
feature -- Status report

	is_A_less_than_or_equal_to_B (a, b: like item): BOOLEAN
			-- 
		deferred
		end
		
end
