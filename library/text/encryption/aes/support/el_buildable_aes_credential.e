note
	description: "AES credentials buildable from Pyxis format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-13 8:51:59 GMT (Thursday 13th May 2021)"
	revision: "7"

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