note
	description: "[
		Compare getting dynamic_type for [$source COLLECTION [ANY]]} from calls
		 
			1. {COLLECTION [ANY]}.type_id
			2. Class_id.COLLECTION_ANY
	]"
	notes: "[
		**RESULTS:** Assign type_id 10000 times
		
		Passes over 500 millisecs (in descending order)

			COLLECTION_ANY     :  34241.0 times (100%)
			{COLLECTION [ANY]} :    359.0 times (-99.0%)

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-03 10:23:17 GMT (Sunday 3rd December 2023)"
	revision: "2"

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
				["COLLECTION_ANY", agent from_enumeration (n)],
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
			Result := Class_id.COLLECTION_ANY
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