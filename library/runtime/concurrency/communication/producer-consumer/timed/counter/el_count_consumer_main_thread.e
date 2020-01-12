note
	description: "Count consumer main thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 16:23:49 GMT (Saturday 11th January 2020)"
	revision: "6"

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
