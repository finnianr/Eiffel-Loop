note
	description: "Locale warning dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_LOCALE_WARNING_DIALOG

inherit
	EV_WARNING_DIALOG

create
	default_create,
	make_with_text,
	make_with_text_and_actions

end