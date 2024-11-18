note
	description: "Command line argument for setting operand of make routine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-18 11:21:27 GMT (Monday 18th November 2024)"
	revision: "30"

class
	EL_COMMAND_ARGUMENT

inherit
	ANY

	EL_FACTORY_CLIENT

	EL_MODULE_ARGS
		rename
			Args as Command_line_arguments
		end

create
	make

feature {NONE} -- Initialization

	make (a_manager: EL_FALLIBLE; a_word_option, a_help_description: READABLE_STRING_GENERAL)
		do
			manager := a_manager; word_option := a_word_option
			create help_description.make_from_general (a_help_description)
			create validation_table.make_equal (0)
			operands := Default_operands
			command_line := Command_line_arguments
		end

feature -- Access

	help_description: ZSTRING

	manager: EL_FALLIBLE

	string_value: ZSTRING
		do
			Result := command_line.value (word_option)
		end

	validation_table: EL_ZSTRING_HASH_TABLE [PREDICATE]
		-- table of argument validation checks by description

	word_option: READABLE_STRING_GENERAL

feature -- Status query

	exists: BOOLEAN
		do
			Result := command_line.option_exists (word_option)
		end

	has_value: BOOLEAN
		do
			Result := command_line.has_value (word_option)
		end

	is_required: BOOLEAN

	is_value_list: BOOLEAN
		do
			Result := command_line.is_value_list (word_option)
		end

	operands_and_index_set: BOOLEAN
		do
			if operands /= Default_operands then
				Result := index > 0 and then operands.valid_index (index)
			end
		end

	path_exists: BOOLEAN
		do
		end

feature -- Conversion

	as_value_list: EL_ZSTRING_LIST
		do
			Result := command_line.value_list (word_option)
		end

feature -- Basic operations

	try_put_argument
		-- attempt to set value at `operands.at (index)' using corresponding command line argument
		require
			operands_and_index_set: operands_and_index_set
		local
			setter: detachable EL_MAKE_OPERAND_SETTER [ANY]; operand_type: TYPE [ANY]
			operand: ANY
		do
			operand := operands.item (index)
			operand_type := operand.generating_type
			if Setter_types.has_key (operand_type) then
				if attached Factory.new_item_from_type (Setter_types.found_item) as new_item then
					new_item.make (Current)
					setter := new_item
				end

			elseif attached {EL_MAKEABLE_FROM_STRING [STRING_GENERAL]} operand as makeable then
				create {EL_MAKEABLE_FROM_ZSTRING_OPERAND_SETTER} setter.make (Current)

			elseif attached {EL_BUILDABLE_FROM_FILE} operand as buildable then
				create {EL_BUILDABLE_FROM_FILE_OPERAND_SETTER} setter.make (Current)

			elseif attached {BAG [ANY]} operand as bag then
				if attached {EL_CONTAINER_STRUCTURE [ANY]} operand as container then
					Setter_types.search (container.item_type)

				elseif bag.generating_type.generic_parameter_count = 1 then
					Setter_types.search (bag.generating_type.generic_parameter_type (1))
				else
					Setter_types.search ({NONE}) -- `Setter_types.found' is now False
				end
				if Setter_types.found and then
					attached Factory.new_item_from_type (Setter_types.found_item) as new_item
				then
					new_item.make_list (Current)
					setter := new_item
				end
			end
			if attached setter as s then
				s.try_put_operand
			end
		end

feature -- Status change

	set_operands (a_operands: TUPLE; a_index: INTEGER)
		do
			operands := a_operands; index := a_index
		end

	set_optional
		do
			is_required := False
		end

	set_required
		do
			is_required := True
		end

feature -- Element change

	set_command_line (a_command_line: EL_COMMAND_LINE_ARGUMENTS)
		do
			command_line := a_command_line
		end

feature {EL_MAKE_OPERAND_SETTER} -- Internal attributes

	command_line: EL_COMMAND_LINE_ARGUMENTS

	index: INTEGER

	operands: TUPLE

feature {NONE} -- Constants

	Default_operands: TUPLE
		once ("PROCESS")
			create Result
		end

	Factory: EL_OBJECT_FACTORY [EL_MAKE_OPERAND_SETTER [ANY]]
		once
			create Result
		end

	Setter_types: EL_TYPE_TABLE [TYPE [EL_MAKE_OPERAND_SETTER [ANY]]]
		once
			create Result.make_assignments (<<
--				Basic setters
				[{CHARACTER_8},							{EL_OPERAND_SETTER [CHARACTER_8]}],
				[{CHARACTER_32},							{EL_OPERAND_SETTER [CHARACTER_32]}],

				[{INTEGER_8},								{EL_OPERAND_SETTER [INTEGER_8]}],
				[{INTEGER_16},								{EL_OPERAND_SETTER [INTEGER_16]}],
				[{INTEGER_32},								{EL_OPERAND_SETTER [INTEGER_32]}],
				[{INTEGER_64},								{EL_OPERAND_SETTER [INTEGER_64]}],

				[{NATURAL_8},								{EL_OPERAND_SETTER [NATURAL_8]}],
				[{NATURAL_16},								{EL_OPERAND_SETTER [NATURAL_16]}],
				[{NATURAL_32},								{EL_OPERAND_SETTER [NATURAL_32]}],
				[{NATURAL_64},								{EL_OPERAND_SETTER [NATURAL_64]}],

				[{REAL_32},									{EL_OPERAND_SETTER [REAL_32]}],
				[{REAL_64},									{EL_OPERAND_SETTER [REAL_64]}],

				[{ZSTRING},									{EL_OPERAND_SETTER [ZSTRING]}],
				[{STRING_8},								{EL_OPERAND_SETTER [STRING_8]}],
				[{STRING_32},								{EL_OPERAND_SETTER [STRING_32]}],

				[{EL_DIR_URI_PATH},						{EL_OPERAND_SETTER [EL_DIR_URI_PATH]}],
				[{EL_FILE_URI_PATH},						{EL_OPERAND_SETTER [EL_FILE_URI_PATH]}],

--				Specialized setters
				[{BOOLEAN},									{EL_BOOLEAN_OPERAND_SETTER}],

				[{FILE_PATH},								{EL_PATH_OPERAND_SETTER [FILE_PATH]}],
				[{DIR_PATH},								{EL_PATH_OPERAND_SETTER [DIR_PATH]}],

				[{EL_ZSTRING_HASH_TABLE [ZSTRING]}, {EL_ZSTRING_TABLE_OPERAND_SETTER}]
			>>)
		end

end