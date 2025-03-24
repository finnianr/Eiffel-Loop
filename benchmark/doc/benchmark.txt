**SUB-APPLICATIONS**

The benchmark application has a total of 4 sub-applications that each serve a different purpose
and can be reached with a command option obtained by lower-casing the class name and removing the "_app" suffix.

	EL_APPLICATION*
		${PRIMES_BENCHMARK_APP}
		${EL_COMMAND_LINE_APPLICATION* [C -> EL_APPLICATION_COMMAND]}
			${EL_COMMAND_SHELL_APPLICATION* [C -> EL_APPLICATION_COMMAND_SHELL]}
				${BENCHMARK_APP}
				${STRING_BENCHMARK_APP}
			${ZSTRING_BENCHMARK_APP}

**HEIRARCHY**

The descendants of ${EL_BENCHMARK_COMPARISON} below were created to benchmark particular
code characteristics. Any of the benchmarks can be run from a menu shell.

The class ${DEVELOPER_COMPARISON} is used to create throw-away benchmarks that 
answer particular questions. After benchmarking new code, it is discarded but the
results are documented in the section "Benchmark Journal" below.


	EL_BENCHMARK_COMPARISON*
		${STRING_BENCHMARK_COMPARISON*}
			${SUBSTRING_INDEX_COMPARISON}
			${ZSTRING_DEVELOPER_COMPARISON}
			${ARRAYED_INTERVAL_LIST_COMPARISON}
			${IMMUTABLE_STRING_SPLIT_COMPARISON}
			${LINE_STATE_MACHINE_COMPARISON}
			${MAKE_GENERAL_COMPARISON}
			${STRING_ITEM_8_VS_ITEM}
			${REPLACE_SUBSTRING_ALL_VS_GENERAL}
			${COMPACT_SUBSTRINGS_32_ITERATION_COMPARISON}
			${COMPACT_SUBSTRINGS_32_BUFFERING_COMPARISON}
			${UNICODE_ITEM_COMPARISON}
			${ZCODEC_AS_Z_CODE}
			${ZSTRING_APPEND_GENERAL_VS_APPEND}
			${ZSTRING_APPEND_Z_CODE_VS_APPEND_CHARACTER}
			${ZSTRING_AREA_ITERATION_COMPARISON}
			${ZSTRING_INTERVAL_SEARCH_COMPARISON}
			${ZSTRING_SAME_CHARACTERS_COMPARISON}
			${ZSTRING_SPLIT_COMPARISON}
			${ZSTRING_TOKENIZATION_COMPARISON}
			${ZSTRING_UNICODE_TO_Z_CODE}
			${STRING_SPLIT_ITERATION_COMPARISON}
			${IF_ATTACHED_ITEM_VS_CONFORMING_INSTANCE_TABLE}
			${ZSTRING_SPLIT_LIST_COMPARISON}
			${STRING_CONCATENATION_COMPARISON}
			${STRING_8_TWIN_VS_SCOPE_COPIED_ITEM}
		${ARRAYED_VS_HASH_SET_SEARCH}
		${ATTACH_TEST_VS_BOOLEAN_COMPARISON}
		${BIT_POP_COUNT_COMPARISON}
		${BIT_SHIFT_COUNT_COMPARISON}
		${CLASS_ID_ENUM_VS_TYPE_OBJECT}
		${DIRECTORY_WALK_VS_FIND_COMMAND}
		${HASH_TABLE_VS_NAMEABLES_LIST_SEARCH}
		${LIST_ITERATION_COMPARISON}
		${P_I_TH_LOWER_UPPER_VS_INLINE_CODE}
		${REFLECTED_REFERENCE_VS_OPTIMIZED_FIELD_RW}
		${ROUTINE_CALL_ON_ONCE_VS_EXPANDED}
		${SYSTEM_TIME_COMPARISON}
		${TOKENIZED_STEPS_VS_XPATH_STRING}
		${ARRAYED_VS_LINKED_LIST}
		${STRING_8_SPLIT_VS_SPLIT_ON_CHARACTER_8}
		${COMPACTABLE_REFLECTIVE_VS_MANUAL_BIT_MASK}
		${DEVELOPER_COMPARISON}


**BENCHMARK JOURNAL**

**23 March 2025**

Find fastest way to test `detachable representation' to increment the counter.
The fastest method is to test if `representation = Void'. Other methods are 1/3 slower.

	when 1 then
		if attached {EL_STRING_FIELD_REPRESENTATION [INTEGER, ANY]} representation as l_rep then
			do_nothing
		else
			counter := counter + 1
		end

	when 2 then
		if representation = Void then
			counter := counter + 1

		elseif attached {EL_STRING_FIELD_REPRESENTATION [INTEGER, ANY]} representation as l_rep then
			do_nothing
		end

	when 3 then
		if has_representation
			and then attached {EL_STRING_FIELD_REPRESENTATION [INTEGER, ANY]} representation as l_rep
		then
			do_nothing
		else
			counter := counter + 1
		end


Passes over 500 millisecs (in descending order)

	method 2 :  47911.0 times (100%)
	method 3 :  32334.0 times (-32.5%)
	method 1 :  31783.0 times (-33.7%)

**6 October 2024**

Finding a ${ZSTRING} type at the end of list of 500 STRING_8 objects.

	Result := across string_general_list as list
		1. some list.item.generating_type = {ZSTRING}
		2. some {ISE_RUNTIME}.dynamic_type (list.item) = ZSTRING -- THE WINNER
		3. some {ISE_RUNTIME}.dynamic_type (list.item) = ({ZSTRING}).type_id
		4. some list.item.same_type (Zstring_object)
	end

Passes over 2000 millisecs (in descending order)

	method 2 :  65.0 times (100%)
	method 4 :  63.0 times (-3.1%)
	method 3 :  18.0 times (-72.3%)
	method 1 :  15.0 times (-76.9%)

**26 August 2024**

Testing if ${ZSTRING} conforms to ${READABLE_STRING_32} using class ${EL_INTERNAL}
and ${EL_CLASS_TYPE_ID_ENUM}

	when 1 then
		Result := attached {READABLE_STRING_32} str
	when 2 then
		Result := field_conforms_to (dynamic_type (str), class_id.READABLE_STRING_32)
	when 3 then
		Result := class_id.readable_string_32_types.has (dynamic_type (str)) -- ARRAY [INTEGER]
	when 4 then
		Result := is_type_in_set (dynamic_type (str), class_id.readable_string_32_types) -- THE WINNER

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
