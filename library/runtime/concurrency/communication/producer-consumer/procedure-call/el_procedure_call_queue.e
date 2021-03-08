note
	description: "Procedure call queue"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 15:25:04 GMT (Saturday 6th March 2021)"
	revision: "6"

class
	EL_PROCEDURE_CALL_QUEUE

inherit
	EL_THREAD_PRODUCT_QUEUE	[PROCEDURE]

create
	make

end