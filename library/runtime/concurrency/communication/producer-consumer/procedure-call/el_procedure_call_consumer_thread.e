note
	description: "Procedure call consumer thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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