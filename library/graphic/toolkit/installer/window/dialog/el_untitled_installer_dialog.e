note
	description: "Untitled installer dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 13:52:49 GMT (Saturday 11th June 2022)"
	revision: "9"

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

	EL_MODULE_SCREEN

	EL_MODULE_GUI

	EL_MODULE_LIO

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

feature {NONE} -- Constants

	A5_landscape: TUPLE [width, height: REAL]
		once
			create Result
			Result.width := 21; Result.height := 14.8
		end

end