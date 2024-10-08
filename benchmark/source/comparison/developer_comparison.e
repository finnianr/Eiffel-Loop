note
	description: "Once off comparisons for developer testing"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-06 12:16:43 GMT (Sunday 6th October 2024)"
	revision: "12"

class
	DEVELOPER_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	TIME_CONSTANTS

	EL_MODULE_EIFFEL

create
	make

feature -- Access

	Description: STRING = "Development method comparisons"

feature -- Basic operations

	execute
		local
			ref_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
			range: INTEGER_INTERVAL
		do
			range := 1 |..| 500
			create ref_list.make (range.count)
			across range as n loop
				ref_list.extend (create {STRING_8}.make_empty)
			end
			ref_list.extend (create {ZSTRING}.make_empty)

			compare ("perform benchmark", <<
				["method 1", agent do_method (1, ref_list)],
				["method 2", agent do_method (2, ref_list)],
				["method 3", agent do_method (3, ref_list)],
				["method 4", agent do_method (4, ref_list)]
			>>)
		end

feature {NONE} -- Operations

	do_method (id: INTEGER; ref_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			i: INTEGER; exists: BOOLEAN
		do
			from until i > Repetition_count loop
				inspect id
					when 1 then
						exists := across ref_list as list some list.item.generating_type = {ZSTRING} end
					when 2 then
						exists := across ref_list as list some {ISE_RUNTIME}.dynamic_type (list.item) = ZSTRING end
					when 3 then
						exists := across ref_list as list some {ISE_RUNTIME}.dynamic_type (list.item) = ({ZSTRING}).type_id end
					when 4 then
						exists := across ref_list as list some list.item.same_type (Zstring_object) end
				end
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Repetition_count: INTEGER = 2000

	ZSTRING: INTEGER
		once
			Result := ({ZSTRING}).type_id
		end

	Zstring_object: ZSTRING
		once
			create Result.make_empty
		end

note
	notes: "[
		**6 October 2024**
		
		Finding a ZSTRING type at the end of list of 500 STRING_8 objects.
		
			across string_general_list as list
			
		1. some list.item.generating_type = {ZSTRING} end
		2. some {ISE_RUNTIME}.dynamic_type (list.item) = ZSTRING end (** THE WINNER **)
		3. some {ISE_RUNTIME}.dynamic_type (list.item) = ({ZSTRING}).type_id end
		4. some list.item.same_type (Zstring_object)

		Passes over 2000 millisecs (in descending order)

			method 2 :  65.0 times (100%)
			method 4 :  63.0 times (-3.1%)
			method 3 :  18.0 times (-72.3%)
			method 1 :  15.0 times (-76.9%)

		**26 August 2024**
		
		Testing if ${ZSTRING} conforms to ${READABLE_STRING_32} using class ${EL_INTERNAL}
		and ${EL_CLASS_TYPE_ID_ENUM}
		
		1. Result := attached {READABLE_STRING_32} str
		2. Result := field_conforms_to (dynamic_type (str), class_id.READABLE_STRING_32)
		3. Result := class_id.readable_string_32_types.has (dynamic_type (str)) -- ARRAY [INTEGER]
		4. Result := is_type_in_set (dynamic_type (str), class_id.readable_string_32_types) (** THE WINNER **)
		
		Passes over 500 millisecs (in descending order)

			method 4 :  7399.0 times (100%)
			method 3 :  4725.0 times (-36.1%)
			method 1 :  4272.0 times (-42.3%)
			method 2 :  3300.0 times (-55.4%)
		
		**5 June 2024**
		
		Loop to remove steps until path does not have a parent

			path.parent:        43.0 times (100%)
			steps.remove_tail:  25.0 times (-41.9%)
	
		**13 April 2024**
		
		Method for ${EL_INTEGER_MATH}.natural_digit_count

		Passes over 500 millisecs (in descending order)

			quotient := quotient // 10 :  422.0 times (100%)
			{DOUBLE_MATH}.log10        :  196.0 times (-53.6%)

		**13 Dec 2023**

		Passes over 500 millisecs (in descending order)

			C_date: C_DATE; System_time: EL_SYSTEM_TIME

			System_time.update:	231.0 times (100%)
			C_date.update:			105.0 times (-54.5%)
	]"

end