note
	description: "Summary description for {EL_LOCALE_WARNING_DIALOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_LOCALE_WARNING_DIALOG

inherit
	EV_WARNING_DIALOG

create
	default_create,
	make_with_text,
	make_with_text_and_actions

end
