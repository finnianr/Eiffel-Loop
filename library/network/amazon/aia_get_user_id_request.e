note
	description: "Summary description for {AIA_GET_USER_ID_REQUEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-27 14:13:22 GMT (Monday 27th November 2017)"
	revision: "1"

class
	AIA_GET_USER_ID_REQUEST

inherit
	AIA_REQUEST

create
	make

feature -- Access

	info_field_1: ZSTRING

	info_field_2: ZSTRING

	info_field_3: ZSTRING

feature {NONE} -- Implementation

	json_response: STRING
		do
		end

end
