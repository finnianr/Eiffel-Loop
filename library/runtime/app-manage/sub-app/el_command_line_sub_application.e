note
	description: "[
		An object that maps command line arguments to an Eiffel make procedure for a target object (command).
		The 'command' object is automically created and the make procedure specified by 'make_action'
		is called to intialize it.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-09 11:42:49 GMT (Friday 9th June 2017)"
	revision: "5"

deferred class
	EL_COMMAND_LINE_SUB_APPLICATION [C -> EL_COMMAND create default_create end]

inherit
	EL_SUB_APPLICATION
		export
			{EL_COMMAND_ARGUMENT} new_argument_error
		end

	EL_MODULE_EIFFEL

	EL_COMMAND_CLIENT

	EL_MODULE_OS

feature {NONE} -- Initiliazation

	initialize
			--
		do
			create command
			set_operands
			if not has_argument_errors then
				make_command
			end
		end

feature -- Basic operations

	run
			--
		do
			command.execute
		end

feature {NONE} -- Argument setting

	set_operands
		do
			operands := default_operands
			create specs.make_from_array (argument_specs)
			specs.do_all_with_index (agent {EL_COMMAND_ARGUMENT}.set_operand)
		end

feature {NONE} -- Factory

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
			Result := ["The file must exist", agent {EL_FILE_PATH}.exists]
		end

	directory_must_exist: like always_valid
		do
			Result := ["The directory must exist", agent {EL_DIR_PATH}.exists]
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
			-- argument specifications
		deferred
		ensure
			valid_specs_count: Result.count <= default_operands.count
		end

	default_operands: TUPLE
			-- default arguments for make action
		deferred
		end

	make_action: PROCEDURE
		deferred
		end

	make_command
		local
			action: like make_action
		do
			action := make_action
			action.set_operands (operands)
			action.apply
		end

feature {EL_COMMAND_ARGUMENT, EL_MAKE_OPERAND_SETTER} -- Internal attributes

	command: C

	operands: TUPLE
		-- make procedure operands

	specs: ARRAYED_LIST [EL_COMMAND_ARGUMENT]

end
