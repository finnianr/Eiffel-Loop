note
	description: "Object that is localizeable according to language attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_LOCALIZED

inherit
	EL_LOCALIZEABLE

create
	make

feature {NONE} -- Initialization

	make (a_langage: STRING)
		do
			language := a_langage
		end

feature -- Access

	language: STRING
end