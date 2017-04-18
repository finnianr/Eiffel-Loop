note
	description: "Summary description for {EL_STRING_FIELD_VALUE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-24 13:44:19 GMT (Tuesday 24th January 2017)"
	revision: "1"

class
	EL_STRING_FIELD_VALUE_TABLE [S -> STRING_GENERAL create make end]

inherit
	EL_REFERENCE_FIELD_VALUE_TABLE [S]
		redefine
			set_conditional_value
		end

create
	make
	
feature -- Element change

	set_escaper (a_escaper: like escaper)
		do
			escaper := a_escaper
		end

feature {NONE} -- Implementation

	set_conditional_value (key: STRING; new: like item)
		do
			if attached escaper then
				Precursor (key, escaper.escaped (new))
			else
				Precursor (key, new)
			end
		end

feature {NONE} -- Internal attributes

	escaper: detachable EL_CHARACTER_ESCAPER [S]

end
