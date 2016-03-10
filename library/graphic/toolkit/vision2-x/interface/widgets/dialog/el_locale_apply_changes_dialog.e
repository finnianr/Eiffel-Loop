note
	description: "Summary description for {EL_LOCALE_APPLY_CHANGES_DIALOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_LOCALE_APPLY_CHANGES_DIALOG

inherit
	EL_LOCALE_SAVE_CHANGES_DIALOG
		redefine
			ev_ok
		end

create
	default_create, make_with_text, make_with_text_and_actions

feature -- Access

	ev_ok: STRING
			--
		do
			Result := Locale * "Apply"
		end

end
