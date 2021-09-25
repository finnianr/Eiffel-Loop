note
	description: "Object that is localizeable according to language attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-25 12:00:38 GMT (Saturday 25th September 2021)"
	revision: "2"

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