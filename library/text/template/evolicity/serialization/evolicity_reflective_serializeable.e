note
	description: "Reflective Evolicity serializeable context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-13 9:28:29 GMT (Tuesday 13th November 2018)"
	revision: "1"

deferred class
	EVOLICITY_REFLECTIVE_SERIALIZEABLE

inherit
	EVOLICITY_SERIALIZEABLE
		undefine
			context_item, is_equal
		redefine
			make_default
		end

	EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT
		undefine
			is_equal, make_default, new_getter_functions
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			import_name as import_default
		redefine
			make_default, Except_fields
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REFLECTIVELY_SETTABLE}
			Precursor {EVOLICITY_SERIALIZEABLE}
		end

feature {NONE} -- Constants

	Except_fields: STRING
			-- list of comma-separated fields to be excluded
		once
			Result := Precursor + ", internal_encoding, output_path, template_path"
		end
end
