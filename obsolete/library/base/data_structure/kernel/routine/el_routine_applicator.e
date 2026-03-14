note
	description: "Apply routine with argument of type G"
	notes: "[
		The purpose of this class is to reuse argument tuples across calls resulting in less garbage collection
		
		This [http://www.eiffel-loop.com/test/source/benchmark/summator/set_routine_argument_comparison.html
		benchmark] shows that infact it adds 40% to the execution time, so it is now obsolete
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-14 11:54:59 GMT (Wednesday 14th November 2018)"
	revision: "1"

class
	EL_ROUTINE_APPLICATOR [G]

create
	make

feature {NONE} -- Initialization

	make
		do
			create operands
		end

feature -- Basic operations

	apply (routine: ROUTINE; argument: G)
		-- apply `routine' with `argument'
		require
			valid_type: valid_type (argument)
			valid_operand: routine.valid_operands ([argument])
		do
			if routine.operands = operands then
				set_operands (operands, argument)
			else
				operands := [argument]
				routine.set_operands (operands)
			end
			routine.apply
		end

feature -- Contract Support

	valid_type (argument: G): BOOLEAN
		do
			Result := operands.valid_type_for_index (argument, 1)
		end

feature {NONE} -- Implementation

	set_operands (a_operands: like operands; argument: G)
		do
			a_operands.put (argument, 1)
		end

feature {NONE} -- Internal attributes

	operands: TUPLE [G];

note
	descendants: "[
			EL_ROUTINE_APPLICATOR
				[$source EL_STATE_MACHINE]
					[$source EL_HTTP_COOKIE_TABLE]
					[$source EL_HTTP_HEADERS]
					[$source EL_COMMA_SEPARATED_LINE_PARSER]
						[$source EL_UTF_8_COMMA_SEPARATED_LINE_PARSER]
					[$source EL_PLAIN_TEXT_LINE_STATE_MACHINE]
						[$source EL_SEND_MAIL_COMMAND_I]*
							[$source EL_SEND_MAIL_COMMAND_IMP]
						[$source EL_IP_ADAPTER_INFO_COMMAND_I]*
							[$source EL_IP_ADAPTER_INFO_COMMAND_IMP]
						[$source EL_GVFS_OS_COMMAND]
							[$source EL_GVFS_FILE_EXISTS_COMMAND]
							[$source EL_GVFS_REMOVE_FILE_COMMAND]
							[$source EL_GVFS_FILE_LIST_COMMAND]
							[$source EL_GVFS_FILE_COUNT_COMMAND]
							[$source EL_GVFS_MOUNT_LIST_COMMAND]
						[$source EL_AUDIO_PROPERTIES_COMMAND_I]*
							[$source EL_AUDIO_PROPERTIES_COMMAND_IMP]
						[$source EL_PYXIS_PARSER]
				[$source EL_CHAIN_SUMMATOR]
				[$source EL_CHAIN_STRING_LIST_COMPILER]
				[$source EL_ROUTINE_QUERY_CONDITION]
					[$source EL_PREDICATE_QUERY_CONDITION]
					[$source EL_FUNCTION_VALUE_QUERY_CONDITION]
				[$source EL_ROUTINE_REFERENCE_APPLICATOR]
					[$source EL_SPLIT_STRING_LIST]
						[$source EL_SPLIT_ZSTRING_LIST]
					[$source EL_PLAIN_TEXT_LINE_STATE_MACHINE]
					[$source ECD_LIST_INDEX]
	]"
end
