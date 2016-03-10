note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-25 10:19:23 GMT (Saturday 25th April 2015)"
	revision: "2"

class
	EL_TUPLE_CONSUMER_THREAD [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_TUPLE_CONSUMER [BASE_TYPE, OPEN_ARGS]
		undefine
			is_equal, copy
		redefine
			make_default
		end

	EL_CONSUMER_THREAD [OPEN_ARGS]
		rename
			consume_product as consume_tuple,
			product as tuple
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_TUPLE_CONSUMER}
			Precursor {EL_CONSUMER_THREAD}
		end

end
