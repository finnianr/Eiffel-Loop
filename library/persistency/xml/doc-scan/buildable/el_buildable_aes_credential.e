note
	description: "AES credentials buildable from document node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:20:20 GMT (Sunday 22nd September 2024)"
	revision: "15"

class
	EL_BUILDABLE_AES_CREDENTIAL

inherit
	EL_AES_CREDENTIAL
		redefine
			make
		end

	EVOLICITY_EIFFEL_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

create
	make_valid, make

feature {NONE} -- Initialization

	make
		do
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EL_AES_CREDENTIAL}
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
		end

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make_assignments (<<
				["salt/text()",	agent do set_salt (node) end],
				["digest/text()",	agent do set_target (node) end]
			>>)
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["digest", agent target_base_64],
				["salt",	  agent salt_base_64]
			>>)
		end

end