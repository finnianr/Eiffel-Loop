note
	description: "Uninstall confirmation dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 13:56:20 GMT (Saturday 11th June 2022)"
	revision: "3"

class
	EL_UNINSTALL_DIALOG

inherit
	EL_MODELED_INFORMATION_DIALOG
		rename
			make as make_dialog
		redefine
			destroy, on_default
		end

	EL_MODULE_SCREEN

	EL_MODULE_WIDGET

	EL_SHARED_DEFAULT_PIXMAPS; EL_SHARED_INSTALL_TEXTS; EL_SHARED_WORD

create
	make

feature {NONE} -- Initialization

	make (app: EL_UNINSTALL_APP)
		do
			if attached new_model (app.name) as m then
				m.set_text (app.Text.uninstall_warning + "%N%N" + Text.uninstall_proceed)
				make_dialog (m, agent app.do_uninstall)
				GUI.do_once_on_idle (agent cancel_button.set_focus)
			end
		end

feature {NONE} -- Implementation

	on_default
		do
			default_button.disable_sensitive
			Widget.set_busy_pointer (default_button, {EL_DIRECTION}.Top)
			Precursor
			Widget.restore_standard_pointer
			model.set_text (Text.close_uninstall)
			update_paragraphs
			set_default_to_close
		end

	destroy
		do
			Precursor
			GUI.application.destroy
		end

	new_model (a_title: READABLE_STRING_GENERAL): EL_DIALOG_MODEL
		do
			create Result.make (a_title)
			Result.set_buttons (Word.yes, Word.no)
			Result.set_icon (Pixmaps.Question_pixmap)
		end
end