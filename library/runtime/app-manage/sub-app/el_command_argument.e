note
	description: "Summary description for {EL_COMMAND_ARGUMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-16 8:42:34 GMT (Monday 16th October 2017)"
	revision: "6"

class
	EL_COMMAND_ARGUMENT

inherit
	EL_MODULE_ARGS

	EL_FACTORY_CLIENT

create
	make

feature {NONE} -- Initialization

	make (a_app: like app; a_word_option, a_help_description: ZSTRING)
		do
			app := a_app; word_option := a_word_option; help_description := a_help_description
			create validation.make_equal (0)
		end

feature -- Access

	help_description: ZSTRING

	validation: EL_ZSTRING_HASH_TABLE [PREDICATE]

	word_option: READABLE_STRING_GENERAL

	new_error: EL_COMMAND_ARGUMENT_ERROR
		do
			Result := app.new_argument_error (word_option)
		end

feature -- Status query

	is_required: BOOLEAN

	path_exists: BOOLEAN
		do
		end

feature -- Status change

	set_required
		do
			is_required := True
		end

feature -- Basic operations

	set_operand (a_index: INTEGER)
		local
			setter: EL_MAKE_OPERAND_SETTER [ANY]; operand_type: TYPE [ANY]
			operand: ANY
		do
			index := a_index
			operand := app.operands.item (index)
			app.options_help.extend (word_option, help_description, operand)
			operand_type := operand.generating_type
			Setter_types.search (operand_type)
			if Setter_types.found then
				setter := Factory.instance_from_type (
					Setter_types.found_item, agent {EL_MAKE_OPERAND_SETTER [ANY]}.make (app, Current)
				)
				setter.set_operand (index)

			elseif attached {EL_BUILDABLE_FROM_FILE} operand as buildable then
				create {EL_BUILDABLE_FROM_FILE_OPERAND_SETTER} setter.make (app, Current)
				setter.set_operand (index)

			elseif attached {CHAIN [ANY]} operand as list then
				if list.generating_type.generic_parameter_count = 1 then
					Setter_types.search (list.generating_type.generic_parameter_type (1))
				elseif attached {EL_ZSTRING_LIST} operand then
					Setter_types.search ({ZSTRING})
				elseif attached {EL_FILE_PATH_LIST} operand then
					Setter_types.search ({EL_FILE_PATH})
				else
					Setter_types.search ({like Current}) -- `Setter_types.found' is now False
				end
				if Setter_types.found then
					setter := Factory.instance_from_type (
						Setter_types.found_item, agent {EL_MAKE_OPERAND_SETTER [ANY]}.make_list (app, Current)
					)
					setter.set_operand (index)
				end
			end
		end

feature {NONE} -- Internal attributes

	app: EL_COMMAND_LINE_SUB_APPLICATION [EL_COMMAND]

	index: INTEGER

feature {NONE} -- Constants

	Factory: EL_OBJECT_FACTORY [EL_MAKE_OPERAND_SETTER [ANY]]
		once
			create Result
		end

	Setter_types: EL_HASH_TABLE [TYPE [EL_MAKE_OPERAND_SETTER [ANY]], TYPE [ANY]]
		once
			create Result.make (<<
				[{BOOLEAN},									{EL_BOOLEAN_OPERAND_SETTER}],

				[{INTEGER},									{EL_INTEGER_OPERAND_SETTER}],
				[{INTEGER_64},								{EL_INTEGER_64_OPERAND_SETTER}],
				[{NATURAL},									{EL_NATURAL_OPERAND_SETTER}],
				[{NATURAL_64},								{EL_NATURAL_64_OPERAND_SETTER}],
				[{REAL},										{EL_REAL_OPERAND_SETTER}],
				[{DOUBLE},									{EL_DOUBLE_OPERAND_SETTER}],

				[{ZSTRING},									{EL_ZSTRING_OPERAND_SETTER}],
				[{STRING_8},								{EL_STRING_8_OPERAND_SETTER}],
				[{STRING_32},								{EL_STRING_32_OPERAND_SETTER}],

				[{EL_FILE_PATH},							{EL_FILE_PATH_OPERAND_SETTER}],
				[{EL_DIR_PATH},							{EL_DIR_PATH_OPERAND_SETTER}],

				[{EL_ZSTRING_HASH_TABLE [ZSTRING]}, {EL_ZSTRING_TABLE_OPERAND_SETTER}],

				[{EL_ENVIRON_VARIABLE},					{EL_ENVIRON_VARIABLE_OPERAND_SETTER [EL_ENVIRON_VARIABLE]}],
				[{EL_DIR_PATH_ENVIRON_VARIABLE},		{EL_ENVIRON_VARIABLE_OPERAND_SETTER [EL_DIR_PATH_ENVIRON_VARIABLE]}],
				[{EL_FILE_PATH_ENVIRON_VARIABLE},	{EL_ENVIRON_VARIABLE_OPERAND_SETTER [EL_FILE_PATH_ENVIRON_VARIABLE]}]
			>>)
		end

end
