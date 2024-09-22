note
	description: "Complex double"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 13:39:38 GMT (Sunday 22nd September 2024)"
	revision: "10"

class
	COMPLEX_64

inherit
	COMPLEX_DOUBLE
		rename
			r as real,
			i as imag
		end

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
			create Result.make_assignments (<<
				["real", agent: DOUBLE_REF do Result := real.to_reference end],
				["imag", agent: DOUBLE_REF do Result := imag.to_reference end]
			>>)
		end

end