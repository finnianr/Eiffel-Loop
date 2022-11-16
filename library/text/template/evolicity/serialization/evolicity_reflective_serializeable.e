note
	description: "Reflective Evolicity serializeable context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "9"

deferred class
	EVOLICITY_REFLECTIVE_SERIALIZEABLE

inherit
	EVOLICITY_SERIALIZEABLE
		undefine
			context_item, is_equal, has_variable
		redefine
			make_default
		end

	EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT
		undefine
			is_equal, make_default, new_getter_functions
		end

	EL_REFLECTIVELY_SETTABLE
		redefine
			make_default, Transient_fields
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REFLECTIVELY_SETTABLE}
			Precursor {EVOLICITY_SERIALIZEABLE}
		end

feature {NONE} -- Constants

	Transient_fields: STRING
		-- comma-separated list of fields to be excluded from `field_table'
		once
			Result := "encoding, output_path, template_path"
		end
end