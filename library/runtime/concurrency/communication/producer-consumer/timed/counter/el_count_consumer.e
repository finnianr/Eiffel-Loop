note
	description: "Summary description for {EL_COUNT_CONSUMER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_COUNT_CONSUMER

inherit
	EL_CONSUMER [INTEGER]
		rename
			consume_product as consume_count,
			product as count
		end

end
