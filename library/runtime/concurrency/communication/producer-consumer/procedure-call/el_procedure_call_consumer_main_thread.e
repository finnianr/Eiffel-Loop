note
	description: "Procedure call consumer main thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD [OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_PROCEDURE_CALL_CONSUMER [OPEN_ARGS]
		rename
			make_default as make
		undefine
			stop
		redefine
			make
		end

	EL_CONSUMER_MAIN_THREAD [PROCEDURE [OPEN_ARGS]]
		rename
			make_default as make,
			consume_product as call_procedure,
			product as procedure
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor {EL_PROCEDURE_CALL_CONSUMER}
			Precursor {EL_CONSUMER_MAIN_THREAD}
		end
end
