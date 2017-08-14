note
	description: "Summary description for {EL_LOCALE_SAVE_CHANGES_DIALOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "1"

class
	EL_SAVE_CHANGES_CONFIRMATION_DIALOG

inherit
	EL_CONFIRMATION_DIALOG
		rename
			ev_cancel as English_discard,
			ev_ok as English_save
		redefine
			English_save, English_discard
		end

create
	default_create, make_with_text, make_with_text_and_actions

feature -- Access

	English_save: STRING
			--
		once
			Result := "Save"
		end

	English_discard: STRING
			--
		once
			Result := "Discard"
		end
end
