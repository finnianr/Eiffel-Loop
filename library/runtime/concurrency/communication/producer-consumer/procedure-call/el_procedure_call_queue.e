note
	description: "Procedure call queue"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:06 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_PROCEDURE_CALL_QUEUE [OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_THREAD_PRODUCT_QUEUE	[PROCEDURE [OPEN_ARGS]]

create
	make

end
