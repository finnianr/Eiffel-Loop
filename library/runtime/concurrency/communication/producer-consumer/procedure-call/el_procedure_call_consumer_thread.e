note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 6:35:52 GMT (Sunday 3rd July 2016)"
	revision: "1"

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
