note
	description: "Summary description for {EL_PROCEDURE_CALL_CONSUMER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

deferred class
	EL_PROCEDURE_CALL_CONSUMER [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_CONSUMER [PROCEDURE [BASE_TYPE, OPEN_ARGS]]
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
