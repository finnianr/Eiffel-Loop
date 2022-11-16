note
	description: "Count consumer thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

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