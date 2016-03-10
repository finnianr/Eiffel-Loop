note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-10 15:51:03 GMT (Sunday 10th May 2015)"
	revision: "2"

class
	EL_MUTEX_NUMERIC [N -> NUMERIC create default_create end]

inherit
	EL_MUTEX_CREATEABLE_REFERENCE [N]
		rename
			actual_item as actual_value,
			set_item as set_value
		export
			{NONE} all
		redefine
			actual_value, set_value
		end

feature -- Element change

	set_value (v: like actual_value)
			--
		do
			lock
			actual_value := v
			unlock
		end

	add (v: like actual_value)
			--
		do
			lock
			actual_value := actual_value + v
			unlock
		end

	subtract (v: like actual_value)
			--
		do
			lock
			actual_value := actual_value - v
			unlock
		end

	increment
			--
		local
			numeric: N
		do
			set_value (actual_value + numeric.one)
		end

	decrement
			--
		local
			numeric: N
		do
			set_value (actual_value - numeric.one)
		end

feature -- Access

	value: like actual_value
			--
		do
			lock
			Result := actual_value
			unlock
		end

feature {NONE} -- Implementation

	actual_value: N

end
