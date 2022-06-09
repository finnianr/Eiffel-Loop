note
	description: "Confirmation view dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-09 16:17:33 GMT (Thursday 9th June 2022)"
	revision: "2"

class
	EL_MODELED_CONFIRMATION_DIALOG

inherit
	EL_MODELED_INFORMATION_DIALOG
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