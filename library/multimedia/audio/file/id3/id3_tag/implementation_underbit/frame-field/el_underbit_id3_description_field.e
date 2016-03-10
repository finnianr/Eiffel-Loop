note
	description: "Summary description for {EL_UNDERBIT_ID3_DESCRIPTION_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

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
