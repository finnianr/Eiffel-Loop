note
	description: "Object that consumes tuples in main GUI thread with specified action/actions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-23 13:19:22 GMT (Thursday 23rd April 2015)"
	revision: "2"

class
	EL_TUPLE_CONSUMER_MAIN_THREAD [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_TUPLE_CONSUMER [BASE_TYPE, OPEN_ARGS]
		rename
			make_default as make
		redefine
			make
		end

	EL_CONSUMER_MAIN_THREAD [OPEN_ARGS]
		rename
			make_default as make,
			consume_product as consume_tuple,
			product as tuple
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor {EL_TUPLE_CONSUMER}
			Precursor {EL_CONSUMER_MAIN_THREAD}
		end

end
