note
	description: "Benchmark comparison"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-23 7:16:39 GMT (Sunday 23rd March 2025)"
	revision: "15"

deferred class
	EL_BENCHMARK_COMPARISON

inherit
	EL_COMMAND

	EL_MODULE_LIO

	EL_MODULE_EXECUTABLE

feature {EL_FACTORY_CLIENT} -- Initialization

	make (a_trial_duration: INTEGER_REF)
		do
			trial_duration := a_trial_duration
			initialize
		end

feature -- Access

	description: READABLE_STRING_GENERAL
		deferred
		end

feature -- Basic operations

	execute
		deferred
		end

feature {NONE} -- Implementation

	compare (label: READABLE_STRING_GENERAL; routines: ARRAY [TUPLE [READABLE_STRING_GENERAL, ROUTINE]])
		local
			table: EL_BENCHMARK_ROUTINE_TABLE
		do
			create table.make (label, routines)
			if trial_duration.item.to_boolean then
				table.set_trial_duration (trial_duration.item)
			end
			lio.put_new_line
			lio.put_labeled_string ("Class", generator)
			lio.put_new_line_x2
			lio.put_labeled_string ("BENCHMARKING", table.label)
			lio.put_new_line_x2

			table.perform
			table.print_comparison
			lio.put_new_line
		end

	initialize
		do
			do_nothing
		end

feature {NONE} -- Internal attributes

	trial_duration: INTEGER_REF;

note
	descendants: "[
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
	]"

end