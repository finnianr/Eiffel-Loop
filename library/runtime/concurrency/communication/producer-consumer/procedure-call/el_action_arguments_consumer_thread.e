note
	description: "[
		Consumer of arguments to an action or sequence of actions using a spawned thread
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_ACTION_ARGUMENTS_CONSUMER_THREAD [OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_CONSUMER_THREAD [OPEN_ARGS]
		rename
			make_default as make,
			consume_product as call_actions,
			product as arguments
		redefine
			make
		end

	EL_ACTION_ARGUMENTS_CONSUMER [OPEN_ARGS]
		rename
			make_default as make
		undefine
			is_equal, copy, name, stop
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor {EL_CONSUMER_THREAD}
			Precursor {EL_ACTION_ARGUMENTS_CONSUMER}
		end

end