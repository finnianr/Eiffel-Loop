note
	description: "[
		An object that maps command line arguments to the arguments for an Eiffel make procedure for a
		target object conforming to `[$source EL_COMMAND]'. The `run' procedure simply executes the command.
		The `command' object is automatically created and the make procedure specified by `default_make'
		is applied to intialize it.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-16 10:16:53 GMT (Monday 16th October 2017)"
	revision: "9"

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
