note
	description: "Evolicity reference expression"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:04:25 GMT (Tuesday 18th March 2025)"
	revision: "6"

class
	EVC_REFERENCE_EXPRESSION

feature {NONE} -- Initialization

	make (a_variable_ref: like variable_ref)
			--
		do
			variable_ref := a_variable_ref
		end

feature {NONE} -- Implementation

	variable_ref: EVC_VARIABLE_REFERENCE

end