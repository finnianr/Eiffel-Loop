note
	description: "Count consumer main thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "4"

deferred class
	EL_COUNT_CONSUMER_MAIN_THREAD

inherit
	EL_COUNT_CONSUMER
		undefine
			stop
		end

	EL_CONSUMER_MAIN_THREAD [INTEGER]
		rename
			consume_product as consume_count,
			product as count
		end

end