note
	description: "Summary description for {EL_COUNT_CONSUMER_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_COUNT_CONSUMER_THREAD

inherit
	EL_COUNT_CONSUMER
		undefine
			default_create, is_equal, copy, stop, name
		redefine
			make_default
		end

	EL_CONSUMER_THREAD [INTEGER]
		rename
			consume_product as consume_count,
			product as count
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_COUNT_CONSUMER}
			Precursor {EL_CONSUMER_THREAD}
		end

end