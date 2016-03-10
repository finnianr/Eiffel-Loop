note
	description: "Summary description for {EV_LOCALE_DIALOG_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EV_LOCALE_DIALOG_CONSTANTS

inherit
	EV_DIALOG_CONSTANTS
		redefine
			ev_cancel, ev_save,
			ev_confirmation_dialog_title
		end

	EL_MODULE_LOCALE

feature -- Button texts

	ev_cancel: STRING
			-- Text displayed on "cancel" buttons.
		do
			Result := Locale * Precursor
		end

	ev_save: STRING
			-- Text displayed on "save" buttons.
		do
			Result := Locale * Precursor
		end

feature -- Titles

	ev_confirmation_dialog_title: STRING
			-- Title of EV_CONFIRMATION_DIALOG.
		do
			Result := Locale * Precursor
		end

end
