note
	description: "[
		Hints for reflective classes as to how fields should be mapped to XML attributes/elements
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 13:39:01 GMT (Thursday 5th January 2023)"
	revision: "1"

deferred class
	EL_NODE_HINTS

inherit
	EL_REFLECTIVE_I
		undefine
			is_equal
		end

feature {NONE} -- Constants

	Empty_set: STRING = ""
		-- rename `element_node_fields' as this to exclude all

	Empty_field_set: EL_FIELD_INDICES_SET
		once
			create Result.make_empty
		end

end