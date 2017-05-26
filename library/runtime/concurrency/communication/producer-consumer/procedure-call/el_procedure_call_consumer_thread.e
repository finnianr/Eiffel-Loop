note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:31:05 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	EL_PROCEDURE_CALL_CONSUMER_THREAD [OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_PROCEDURE_CALL_CONSUMER [OPEN_ARGS]
		undefine
			stop, name
		redefine
			make_default
		end

	EL_CONSUMER_THREAD [PROCEDURE [OPEN_ARGS]]
		rename
			consume_product as call_procedure,
			product as procedure
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_PROCEDURE_CALL_CONSUMER}
			Precursor {EL_CONSUMER_THREAD}
		end
end
