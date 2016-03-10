note
	description: "Summary description for {EL_LOCALE_INFORMATION_DIALOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_LOCALE_INFORMATION_DIALOG

inherit
	EV_INFORMATION_DIALOG
		export
			{ANY} label
		undefine
			ev_ok, ev_save, ev_cancel, ev_confirmation_dialog_title
		end

	EV_LOCALE_DIALOG_CONSTANTS
		undefine
			default_create, copy
		end

create
	default_create, make_with_text

end
