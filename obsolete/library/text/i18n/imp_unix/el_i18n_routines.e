note
	description: "Summary description for {EL_I18N_ROUTINES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_I18N_ROUTINES

inherit
	I18N_UNIX_C_FUNCTIONS

create
	make

feature {NONE} -- Initialization

	make
		do
			unix_set_locale ("")
		end

feature -- Access

	language: STRING
		do
			Result := current_locale_id.language
		end

feature {NONE} -- Implementation

	current_locale_id : I18N_LOCALE_ID
		-- current locale id
		-- USELESS: just returns "POSIX". Use $LANG
		do
			create Result.make_from_string (unix_locale_name)
		end

end
