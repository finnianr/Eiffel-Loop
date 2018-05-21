note
	description: "Tuple consumer thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:06 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_TUPLE_CONSUMER_THREAD [OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_TUPLE_CONSUMER [OPEN_ARGS]
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
