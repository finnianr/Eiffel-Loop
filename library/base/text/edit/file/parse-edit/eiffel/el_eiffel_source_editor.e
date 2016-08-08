note
	description: "Summary description for {EL_EIFFEL_SOURCE_EDITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_EIFFEL_SOURCE_EDITOR

inherit
	EL_TEXT_FILE_EDITOR
		redefine
			is_bom_enabled
		end

feature -- Status query

	is_bom_enabled: BOOLEAN
		do
			Result := True
		end
end
