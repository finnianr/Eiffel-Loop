note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:27:47 GMT (Sunday 21st May 2017)"
	revision: "4"

class
	EL_PROCEDURE_CALL_QUEUE [OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_THREAD_PRODUCT_QUEUE	[PROCEDURE [OPEN_ARGS]]

create
	make

end
