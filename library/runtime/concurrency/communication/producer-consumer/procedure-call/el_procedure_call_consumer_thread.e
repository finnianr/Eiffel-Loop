note
	description: "Procedure call consumer thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 13:06:34 GMT (Saturday 6th March 2021)"
	revision: "4"

class
	EL_PROCEDURE_CALL_CONSUMER_THREAD

inherit
	EL_PROCEDURE_CALL_CONSUMER
		rename
			make_default as make
		undefine
			stop, name, make
		end

	EL_CONSUMER_THREAD [PROCEDURE]
		rename
			make_default as make,
			consume_product as call_procedure,
			product as procedure
		end

create
	make

end