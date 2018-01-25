note
	description: "Summary description for {EL_BUILDABLE_PASS_PHRASE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-09 11:02:53 GMT (Saturday 9th December 2017)"
	revision: "3"

class
	EL_BUILDABLE_PASS_PHRASE

inherit
	EL_PASS_PHRASE
		redefine
			make_default
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		redefine
			make_default
		end

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EL_PASS_PHRASE}
		end

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			create Result.make (<<
				["salt/text()", agent do set_salt (node.to_string_32) end],
				["digest/text()", agent do set_digest (node.to_string_32) end]
			>>)
		end

end
