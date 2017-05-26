note
	description: "Summary description for {EL_PROCEDURE_CALL_CONSUMER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:30:45 GMT (Sunday 21st May 2017)"
	revision: "2"

deferred class
	EL_PROCEDURE_CALL_CONSUMER [OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_CONSUMER [PROCEDURE [OPEN_ARGS]]
		rename
			consume_product as call_procedure,
			product as procedure
		end

feature {NONE} -- Implementation

	call_procedure
			--
		do
			procedure.apply
		end

end
