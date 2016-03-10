note
	description: "Summary description for {EL_BUILDABLE_PASS_PHRASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	building_action_table: like Type_building_actions
			--
		do
			create Result.make (<<
				["salt/text()", agent do set_salt (node.to_string_32) end],
				["digest/text()", agent do set_digest (node.to_string_32) end]
			>>)
		end

end
