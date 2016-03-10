note
	description: "Summary description for {EL_LOCALE_ACTION_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_LOCALE_ACTION_EXCEPTION_MANAGER [D -> EL_ERROR_DIALOG create make end]

inherit
	EL_ACTION_EXCEPTION_MANAGER [D]
		redefine
			Default_title, Default_message
		end

	EL_MODULE_LOCALE

create
	make

feature {NONE} -- Constants

	Default_title: EL_ASTRING
		once
			Result := Locale * "ERROR"
		end

	Default_message: EL_ASTRING
		once
			Result := Locale * "{something bad happened}"
		end
end
