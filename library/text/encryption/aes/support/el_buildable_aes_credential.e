note
	description: "AES credentials buildable from document node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-20 8:40:33 GMT (Tuesday 20th June 2023)"
	revision: "9"

class
	EL_BUILDABLE_AES_CREDENTIAL

inherit
	EL_AES_CREDENTIAL
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
			Precursor {EL_AES_CREDENTIAL}
		end

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["salt/text()", agent do set_salt (node) end],
				["digest/text()", agent do set_digest (node) end]
			>>)
		end

end