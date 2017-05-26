note
	description: "Object that consumes tuples in main GUI thread with specified action/actions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:31:54 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	EL_TUPLE_CONSUMER_MAIN_THREAD [OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_TUPLE_CONSUMER [OPEN_ARGS]
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
