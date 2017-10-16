note
	description: "Summary description for {EL_COUNT_CONSUMER_MAIN_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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