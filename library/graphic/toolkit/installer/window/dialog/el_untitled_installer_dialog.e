note
	description: "Untitled installer dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-07 11:57:56 GMT (Friday 7th July 2023)"
	revision: "14"

deferred class
	EL_UNTITLED_INSTALLER_DIALOG

inherit
	EV_UNTITLED_DIALOG
		undefine
			Default_pixmaps
		end

	EL_UI_COMPONENT_FACTORY
		undefine
			default_create, copy
		end

	EL_MODULE_ACTION; EL_MODULE_LIO; EL_MODULE_SCREEN

	EL_SHARED_PAPER_DIMENSIONS

feature -- Status query

	is_cancelled: BOOLEAN

feature {EL_INSTALLER_BOX} -- Event handling

	on_cancel
		do
			destroy
		end

	on_next
		deferred
		end

end