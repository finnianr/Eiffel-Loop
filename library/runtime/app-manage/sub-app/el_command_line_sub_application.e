note
	description: "[
		Maps command line arguments to the arguments of the make procedure of the `command' object
		conforming to `[$source EL_COMMAND]'. If no mapping errors occur during the initilization,
		the `run' procedure is called and executes the command.

		More client examples can be found in class `[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION]'.
	]"
	notes: "[
		Implementing `argument_specs' specifies command option names, a description that becomes part
		of the help text, and validation procedures and associated descriptions.

		Implementing `default_make' provides default arguments for initializing the command, which can
		then be overridden by the command line options specified in `argument_specs'.
		
		The `command.make' routine must be exported to class `EL_COMMAND_CLIENT'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-18 11:47:36 GMT (Wednesday 18th October 2017)"
	revision: "10"

deferred class
	EL_COMMAND_LINE_SUB_APPLICATION [C -> EL_COMMAND]

inherit
	EL_SUB_APPLICATION
		export
			{EL_COMMAND_ARGUMENT} new_argument_error
		end

	EL_COMMAND_CLIENT

feature {NONE} -- Initialization

	initialize
			--
		local
			l_default_make: PROCEDURE; procedure: EL_PROCEDURE
		do
			l_default_make := default_make
			create procedure.make (l_default_make)
			set_operands  (procedure.closed_operands)
			if not has_argument_errors then
				command := factory.instance_from_type ({C}, l_default_make)
			end
		end

feature -- Basic operations

	run
			--
		do
			command.execute
		end

feature {NONE} -- Argument setting

	set_operands (a_operands: like operands)
		do
			operands := a_operands
			create specs.make_from_array (argument_specs)
			specs.do_all_with_index (agent {EL_COMMAND_ARGUMENT}.set_operand)
		end

feature {NONE} -- Implementation

	optional_argument (word_option, help_description: ZSTRING): like specs.item
		do
			create Result.make (Current, word_option, help_description)
		end

	required_argument (word_option, help_description: ZSTRING): like specs.item
		do
			create Result.make (Current, word_option, help_description)
			Result.set_required
		end

	valid_optional_argument (
		word_option, help_description: ZSTRING; validations: ARRAY [like always_valid]
	): like specs.item
		do
			create Result.make (Current, word_option, help_description)
			Result.validation.append_tuples (validations)
		end

	valid_required_argument (
		word_option, help_description: ZSTRING; validations: ARRAY [like always_valid]
	): like specs.item
		do
			Result := required_argument (word_option, help_description)
			Result.validation.append_tuples (validations)
		end

feature {NONE} -- Validations

	always_valid: TUPLE [key: READABLE_STRING_GENERAL; value: PREDICATE]
		do
			Result := ["Always true", agent: BOOLEAN do Result := True end]
		end

	file_must_exist: like always_valid
		do
			Result := [
				"The file must exist", agent (path: EL_FILE_PATH): BOOLEAN
				do
					Result := not path.is_empty implies path.exists
				end
			]
		end

	directory_must_exist: like always_valid
		do
			Result := [
				"The directory must exist", agent (path: EL_DIR_PATH): BOOLEAN
				do
					Result := not path.is_empty implies path.exists
				end
			]
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
			-- argument specifications
		deferred
		ensure
			valid_specs_count: Result.count <= operands.count
		end

	default_make: PROCEDURE
		-- make procedure with open target and default operands
		deferred
		ensure
			closed_except_for_target: Result.open_count = 1 and not Result.is_target_closed
		end

	factory: EL_OBJECT_FACTORY [C]
		do
			create Result
		end

feature {EL_COMMAND_ARGUMENT, EL_MAKE_OPERAND_SETTER} -- Internal attributes

	command: C

	operands: TUPLE
		-- make procedure operands

	specs: ARRAYED_LIST [EL_COMMAND_ARGUMENT]

end
