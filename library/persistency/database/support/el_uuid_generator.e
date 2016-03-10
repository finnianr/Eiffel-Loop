note
	description: "Summary description for {EL_UUID_GENERATOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_UUID_GENERATOR

inherit
	UUID_GENERATOR
		redefine
			generate_uuid
		end

feature -- Access

	generate_uuid: EL_UUID
		local
			l_id: UUID
		do
			l_id := Precursor
			create Result.make (l_id.data_1, l_id.data_2, l_id.data_3, l_id.data_4, l_id.data_5)
		end

end
