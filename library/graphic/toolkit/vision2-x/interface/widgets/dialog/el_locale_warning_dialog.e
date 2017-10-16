note
	description: "Summary description for {EL_LOCALE_WARNING_DIALOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_LOCALE_WARNING_DIALOG

inherit
	EV_WARNING_DIALOG

create
	default_create,
	make_with_text,
	make_with_text_and_actions

end