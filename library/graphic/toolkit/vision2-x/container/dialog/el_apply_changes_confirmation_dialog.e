note
	description: "Apply changes confirmation dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 12:28:42 GMT (Saturday 19th February 2022)"
	revision: "5"

class
	EL_APPLY_CHANGES_CONFIRMATION_DIALOG

inherit
	EL_CONFIRMATION_DIALOG
		redefine
			ev_ok, ev_cancel
		end

create
	default_create, make_with_text, make_with_text_and_actions

feature -- Access

	ev_ok: STRING = "Apply"

	ev_cancel: STRING = "Discard"

end