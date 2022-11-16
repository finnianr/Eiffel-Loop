note
	description: "Procedure call consumer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

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