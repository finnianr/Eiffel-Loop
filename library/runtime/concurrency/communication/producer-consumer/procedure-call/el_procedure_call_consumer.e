note
	description: "Procedure call consumer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 10:47:41 GMT (Saturday 6th March 2021)"
	revision: "5"

deferred class
	EL_PROCEDURE_CALL_CONSUMER

inherit
	EL_CONSUMER [PROCEDURE]
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