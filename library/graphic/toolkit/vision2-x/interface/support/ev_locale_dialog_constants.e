note
	description: "Summary description for {EV_LOCALE_DIALOG_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

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
