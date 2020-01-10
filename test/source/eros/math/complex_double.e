note
	description: "Complex double"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-10 9:35:02 GMT (Friday 10th January 2020)"
	revision: "5"

class
	COMPLEX_DOUBLE

inherit
	NEL_COMPLEX_DOUBLE

	EVOLICITY_EIFFEL_CONTEXT
		rename
			make_default as make
		undefine
			is_equal, out
		end

create
	make

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["real", agent: DOUBLE_REF do Result := r.to_reference end],
				["imag", agent: DOUBLE_REF do Result := i.to_reference end]
			>>)
		end

end
