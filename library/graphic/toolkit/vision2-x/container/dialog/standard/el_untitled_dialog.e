note
	description: "Standard dialog without a title bar"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 14:10:31 GMT (Saturday 11th June 2022)"
	revision: "1"

class
	EL_UNTITLED_DIALOG

inherit
	EV_UNTITLED_DIALOG
		undefine
			Default_pixmaps
		end

	EL_SHARED_DEFAULT_PIXMAPS
end