note
	description: "Summary description for {EL_UNDERBIT_ID3_DESCRIPTION_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_UNDERBIT_ID3_DESCRIPTION_FIELD

inherit
	EL_UNDERBIT_ID3_ENCODED_FIELD
		redefine
			type
		end

create
	make

feature -- Access

	type: INTEGER
		do
			Result := Type_description
		end
end
