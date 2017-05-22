note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-11-17 11:06:13 GMT (Thursday 17th November 2016)"
	revision: "3"

class
	EL_PROCEDURE_CALL_QUEUE [OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_THREAD_PRODUCT_QUEUE	[PROCEDURE [OPEN_ARGS]]

create
	make

end
