note
	description: "Summary description for {EL_UUID_GENERATOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "3"

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
