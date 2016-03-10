note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_PROCEDURE_CALL_QUEUE [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_THREAD_PRODUCT_QUEUE	[PROCEDURE [BASE_TYPE, OPEN_ARGS]]

create
	make
	
end
