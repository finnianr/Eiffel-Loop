note
	description: "Confirmation view dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-14 13:02:05 GMT (Friday 14th August 2020)"
	revision: "1"

class
	EL_CONFIRMATION_VIEW_DIALOG

inherit
	EL_INFORMATION_VIEW_DIALOG
		redefine
			on_default
		end

create
	make

feature {NONE} -- Event handling

	on_default
		do
			destroy
			Precursor
		end
end
