note
	description: "Count consumer thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 13:04:32 GMT (Saturday 6th March 2021)"
	revision: "6"

deferred class
	EL_COUNT_CONSUMER_THREAD

inherit
	EL_COUNT_CONSUMER
		undefine
			stop, name, make_default
		end

	EL_CONSUMER_THREAD [INTEGER]
		rename
			consume_product as consume_count,
			product as count
		end

end