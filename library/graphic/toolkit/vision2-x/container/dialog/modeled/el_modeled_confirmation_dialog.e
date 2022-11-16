note
	description: "Confirmation view dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

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