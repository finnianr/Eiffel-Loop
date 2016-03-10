note
	description: "Summary description for {EL_COUNT_CONSUMER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

deferred class
	EL_COUNT_CONSUMER

inherit
	EL_CONSUMER [INTEGER]
		rename
			consume_product as consume_count,
			product as count
		end

end
