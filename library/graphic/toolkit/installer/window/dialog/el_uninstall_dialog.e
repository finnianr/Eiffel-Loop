note
	description: "Uninstall confirmation dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-08 12:04:40 GMT (Saturday 8th July 2023)"
	revision: "7"

class
	EL_UNINSTALL_DIALOG

inherit
	EL_MODELED_INFORMATION_DIALOG
		rename
			make as make_dialog
		end

	EL_MODULE_SCREEN

	EL_MODULE_WIDGET

	EL_SHARED_DEFAULT_PIXMAPS; EL_SHARED_INSTALL_TEXTS; EL_SHARED_WORD

	EL_SHARED_EV_APPLICATION

create
	make

feature {NONE} -- Initialization

	make (app: EL_UNINSTALL_APP [EL_STOCK_PIXMAPS])
		do
			if attached new_model (app.name) as m then
				m.set_text (app.Text.uninstall_warning + "%N%N" + Text.uninstall_proceed)
				m.enable_application
				make_dialog (m, agent do_uninstall (app))
				Action.do_once_on_idle (agent cancel_button.set_focus)
			end
		end

feature {NONE} -- Implementation

	do_uninstall (app: EL_UNINSTALL_APP [EL_STOCK_PIXMAPS])
		do
			default_button.disable_sensitive
			Widget.set_busy_pointer (default_button, {EL_DIRECTION}.Top)
			app.do_uninstall
			Widget.restore_standard_pointer

			model.set_text (Text.close_uninstall)
			update_paragraphs
			cancel_button.hide
			set_default_to_close
		end

	new_model (a_title: READABLE_STRING_GENERAL): EL_DIALOG_MODEL
		do
			create Result.make (a_title)
			Result.set_buttons (Word.yes, Word.no)
			Result.set_icon (Pixmaps.Question_pixmap)
			Result.enable_application
		end
end