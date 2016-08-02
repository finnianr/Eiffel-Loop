note
	description: "Summary description for {EL_UUID_GENERATOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-29 12:19:01 GMT (Tuesday 29th March 2016)"
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
			u: UUID
		do
			u := Precursor
			create Result.make (u.data_1, u.data_2, u.data_3, u.data_4, u.data_5)
		end

end