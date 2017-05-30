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
	date: "2017-05-30 5:10:51 GMT (Tuesday 30th May 2017)"
	revision: "3"

deferred class
	EL_COMMAND_LINE_SUB_APPLICATION [C -> EL_COMMAND create default_create end]

inherit
	EL_SUB_APPLICATION
		export
			{EL_COMMAND_ARGUMENT} English_integer, English_file, English_directory,
				set_argument_type_error, set_missing_argument_error, set_path_argument_error,
				set_required_argument_error
		end

	EL_MODULE_EIFFEL

	EL_COMMAND_CLIENT

	EL_MODULE_OS

feature {NONE} -- Initiliazation

	initialize
			--
		do
			create command
			create specs.make_from_array (argument_specs)
			set_operands
			if not has_invalid_argument then
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
		require
			valid_specs_count: specs.count <= default_operands.count
		local
			i: INTEGER
		do
			operands := default_operands
			from specs.start until specs.after loop
				i := specs.index
				if operands.is_reference_item (i) then
					specs.item.set_reference_operand (i)

				elseif operands.is_integer_32_item (i) then
					specs.item.set_integer_operand (i)

				elseif operands.is_boolean_item (i) then
					specs.item.set_boolean_operand (i)

				end
				specs.forth
			end
		end

feature {NONE} -- Conversion

	optional_argument (word_option, help_description: ZSTRING): like specs.item
		do
			create Result.make (Current, word_option, help_description)
		end

	required_argument (word_option, help_description: ZSTRING): like specs.item
		do
			create {EL_REQUIRED_COMMAND_ARGUMENT} Result.make (Current, word_option, help_description)
		end

	required_existing_path_argument (word_option, help_description: ZSTRING): like specs.item
		do
			create {EL_EXISTING_PATH_COMMAND_ARGUMENT} Result.make (Current, word_option, help_description)
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
			-- argument specifications
		deferred
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

feature {EL_COMMAND_ARGUMENT} -- Internal attributes

	command: C

	operands: TUPLE
		-- make procedure operands

	specs: ARRAYED_LIST [EL_COMMAND_ARGUMENT]

end
