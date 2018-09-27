note
	description: "Uuid factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_UUID_FACTORY

inherit
	UUID_GENERATOR
		rename
			generate_uuid as new_uuid
		redefine
			new_uuid
		end

feature -- Access

	new_uuid: EL_UUID
		local
			u: UUID
		do
			u := Precursor
			create Result.make (u.data_1, u.data_2, u.data_3, u.data_4, u.data_5)
		end

end
