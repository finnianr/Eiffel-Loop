note
	description: "Summary description for {E2X_COMPLEX_DOUBLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-11 16:59:36 GMT (Wednesday 11th March 2015)"
	revision: "2"

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
