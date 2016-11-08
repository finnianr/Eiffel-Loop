note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-13 8:05:35 GMT (Thursday 13th October 2016)"
	revision: "2"

class
	EL_PROCEDURE_CALL_QUEUE [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_THREAD_PRODUCT_QUEUE	[PROCEDURE [BASE_TYPE, OPEN_ARGS]]
		rename
			put as call
		end

create
	make

end
