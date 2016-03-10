note
	description: "Summary description for {E2X_COMPLEX_DOUBLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	E2X_COMPLEX_DOUBLE

inherit
	COMPLEX_DOUBLE

	EVOLICITY_EIFFEL_CONTEXT
		rename
			make_eiffel_context as make
		undefine
			is_equal, out
		end

create
	make

feature {NONE} -- Evolicity reflection

	get_real: DOUBLE_REF
			--
		do
			Result := r.to_reference
		end

	get_imag: DOUBLE_REF
			--
		do
			Result := i.to_reference
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["real", agent get_real],
				["imag", agent get_imag]
			>>)
		end

end
