note
	description: "Procedure call consumer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "4"

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
