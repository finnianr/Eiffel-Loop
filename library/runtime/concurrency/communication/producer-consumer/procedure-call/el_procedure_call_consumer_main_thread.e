note
	description: "Summary description for {EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_PROCEDURE_CALL_CONSUMER [BASE_TYPE, OPEN_ARGS]
		undefine
			stop
		end

	EL_CONSUMER_MAIN_THREAD [PROCEDURE [BASE_TYPE, OPEN_ARGS]]
		rename
			consume_product as call_procedure,
			product as procedure
		end

create
	make

end
