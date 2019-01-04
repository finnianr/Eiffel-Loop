note
	description: "Object that is localizeable according to language attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-03 15:38:12 GMT (Thursday 3rd January 2019)"
	revision: "1"

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
