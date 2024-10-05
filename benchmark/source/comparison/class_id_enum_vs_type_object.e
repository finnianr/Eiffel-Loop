note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "5"

class
	CLASS_ID_ENUM_VS_TYPE_OBJECT

inherit
	EL_BENCHMARK_COMPARISON

	EL_SHARED_CLASS_ID

create
	make

feature -- Access

	Description: STRING = "Class_id.COLLECTION_ANY VS {COLLECTION [ANY]}.type_id"

feature -- Basic operations

	execute
		local
			n: INTEGER
		do
			n := 10_000
			compare ("Assign type_id " + n.out + " times", <<
				["COLLECTION__ANY", agent from_enumeration (n)],
				["{COLLECTION [ANY]}", agent from_type_in_brackets (n)]
			>>)
		end

feature {NONE} -- el_os_routines_i

	from_enumeration (n: INTEGER)
		local
			i, type_id: INTEGER
		do
			from i := 1 until i > n loop
				type_id := class_id_collection_any
				i := i + 1
			end
		end

	from_type_in_brackets (n: INTEGER)
		local
			i, type_id: INTEGER
		do
			from i := 1 until i > n loop
				type_id := collection_any_type_id
				i := i + 1
			end
		end

	class_id_collection_any: INTEGER
		do
			Result := Class_id.COLLECTION__ANY
		end

	collection_any_type_id: INTEGER
		do
			Result := id ({COLLECTION [ANY]})
		end

	id (type: TYPE [ANY]): INTEGER
		do
			Result := type.type_id
		end
end