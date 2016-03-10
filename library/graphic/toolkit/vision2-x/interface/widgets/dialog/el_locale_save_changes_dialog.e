note
	description: "Summary description for {EL_LOCALE_SAVE_CHANGES_DIALOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_LOCALE_SAVE_CHANGES_DIALOG

inherit
	EV_CONFIRMATION_DIALOG
		rename
			ev_cancel as ev_discard
		undefine
			ev_discard, ev_save, ev_ok,
			ev_confirmation_dialog_title
		end

	EV_LOCALE_DIALOG_CONSTANTS
		rename
			ev_cancel as ev_discard
		undefine
			default_create, copy
		redefine
			ev_ok, ev_discard
		end

create
	default_create, make_with_text, make_with_text_and_actions

feature -- Access

	ev_ok: STRING
			--
		do
			Result := ev_save
		end

	ev_discard: STRING
			--
		do
			Result := Locale * "Discard"
		end
end
