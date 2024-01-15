note
	description: "Hashable class routine key based on name and class type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-15 12:29:24 GMT (Monday 15th January 2024)"
	revision: "6"

class
	EL_ROUTINE_KEY

inherit
	HASHABLE
		redefine
			is_equal
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (a_type_id: INTEGER; a_name: STRING)
		do
			set (a_type_id, a_name)
		end

	make_empty
		do
			create name.make_empty
		end

feature -- Access

	hash_code: INTEGER
		local
			b: EL_BIT_ROUTINES
		do
			Result := b.extended_hash (name.hash_code, type_id)
		end

	name: STRING

	type_id: INTEGER

feature -- Element change

	set (a_type_id: INTEGER; a_name: STRING)
		do
			type_id := a_type_id; name := a_name
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			if Current = other then
				Result := True
			else
				Result := type_id = other.type_id and then name ~ other.name
			end
		end

end