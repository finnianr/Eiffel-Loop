note
	description: "Summary description for {EL_LOCALE_APPLY_CHANGES_DIALOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "1"

class
	EL_APPLY_CHANGES_CONFIRMATION_DIALOG

inherit
	EL_CONFIRMATION_DIALOG
		rename
			ev_cancel as Eng_discard,
			ev_ok as Eng_apply
		redefine
			Eng_apply, Eng_discard
		end

create
	default_create, make_with_text, make_with_text_and_actions

feature -- Access

	Eng_apply: STRING
			--
		once
			Result := "Apply"
		end

	Eng_discard: STRING
			--
		once
			Result := "Discard"
		end
end
