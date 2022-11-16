note
	description: "Standard dialog without a title bar"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_UNTITLED_DIALOG

inherit
	EV_UNTITLED_DIALOG
		undefine
			Default_pixmaps
		end

	EL_SHARED_DEFAULT_PIXMAPS
end