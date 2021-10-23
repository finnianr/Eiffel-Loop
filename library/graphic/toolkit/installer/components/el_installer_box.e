note
	description: "Installer box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-23 10:43:56 GMT (Saturday 23rd October 2021)"
	revision: "6"

class
	EL_INSTALLER_BOX

inherit
	EL_VERTICAL_BOX
		rename
			make as make_box
		end

	EL_UI_COMPONENT_FACTORY
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_GUI

	EL_MODULE_VISION_2

	EL_SHARED_WORD

feature {NONE} -- Initialization

	make (a_dialog: like dialog; a_border_cms, a_padding_cms: REAL)
		do
			dialog := a_dialog
			make_box (a_border_cms, a_padding_cms)
			cancel_button := new_button (Word.cancel, agent dialog.on_cancel)
		end

feature -- Access

	cancel_button: EV_BUTTON

feature {NONE} -- Internal attributes

	dialog: EL_UNTITLED_INSTALLER_DIALOG

end