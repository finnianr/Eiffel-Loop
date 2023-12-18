note
	description: "AES credentials buildable from document node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-18 9:30:44 GMT (Monday 18th December 2023)"
	revision: "14"

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
			create Result.make (<<
				["salt/text()",	agent do set_salt (node) end],
				["digest/text()",	agent do set_target (node) end]
			>>)
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["digest", agent target_base_64],
				["salt",	  agent salt_base_64]
			>>)
		end

end