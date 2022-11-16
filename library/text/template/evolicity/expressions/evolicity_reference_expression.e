note
	description: "Evolicity reference expression"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EVOLICITY_REFERENCE_EXPRESSION

feature {NONE} -- Initialization

	make (a_variable_ref: like variable_ref)
			--
		do
			variable_ref := a_variable_ref
		end

feature {NONE} -- Implementation

	variable_ref: EVOLICITY_VARIABLE_REFERENCE

end