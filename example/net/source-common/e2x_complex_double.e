note
	description: "E2X complex double"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	E2X_COMPLEX_DOUBLE

inherit
	COMPLEX_DOUBLE

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