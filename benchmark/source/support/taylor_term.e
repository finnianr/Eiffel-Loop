note
	description: "Taylor term"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 19:25:24 GMT (Saturday 1st February 2020)"
	revision: "1"

class
	TAYLOR_TERM

inherit
	EVOLICITY_EIFFEL_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (a_divisor, a_numerator: INTEGER)
		do
			make_default
			divisor := a_divisor
			numerator := a_numerator
		end

feature -- Access

	divisor: INTEGER

	numerator: INTEGER

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["divisor", agent: INTEGER_REF do Result := divisor.to_reference end],
				["numerator", agent: INTEGER_REF do Result := numerator.to_reference end]
			>>)
		end
end
