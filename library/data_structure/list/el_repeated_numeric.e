note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_REPEATED_NUMERIC [G -> NUMERIC]

create
	make, make_with_count
	
feature {NONE} -- Initialization	

	make (a_value: like value)
			--
		do
			value := a_value
			count := 1
		end

	make_with_count (a_count: INTEGER_8; a_value: like value)
			--
		do
			value := a_value
			count := a_count
		end

feature -- Basic operations

	increment
			--
		require
			maximum_not_reached: not maximum_reached
		do
			count := count + 1
		end

feature -- Status query

	maximum_reached: BOOLEAN
			--
		do
			Result := count = count.max_value
		end

feature -- Access

	count: INTEGER_8

	value: G

end
