note
	description: "Object that consumes tuples in main GUI thread with specified action/actions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

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
