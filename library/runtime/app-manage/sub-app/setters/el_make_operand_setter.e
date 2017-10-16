note
	description: "[
		Sets the command operands for the generic `command` in class `[$source EL_COMMAND_LINE_SUB_APPLICATION]`
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-16 10:12:35 GMT (Monday 16th October 2017)"
	revision: "5"

deferred class
	EL_MAKE_OPERAND_SETTER [G]

inherit
	EL_MODULE_ARGS

	EL_STRING_CONSTANTS

	EL_MODULE_STRING_8

feature {EL_FACTORY_CLIENT} -- Initialization

	make (a_app: like app; a_argument: like argument)
		do
			app := a_app; argument := a_argument
		end

	make_list (a_app: like app; a_argument: like argument)
		do
			make (a_app, a_argument)
			is_list := True
		end

feature -- Basic operations

	set_operand (i: INTEGER)
		local
			string_value: ZSTRING
		do
			if Args.has_value (argument.word_option) then
				string_value := Args.value (argument.word_option)
			else
				create string_value.make_empty
			end
			if argument.is_required and string_value.is_empty then
				app.argument_errors.extend (argument.new_error)
				app.argument_errors.last.set_missing_argument

			elseif not string_value.is_empty then
				across new_list (string_value) as str loop
					if is_convertible (str.item) then
						try_put_value (value (str.item), i)
					else
						app.argument_errors.extend (argument.new_error)
						app.argument_errors.last.set_type_error (type_description)
					end
				end
			end
		end

feature {NONE} -- Implementation

	is_convertible (string_value: ZSTRING): BOOLEAN
		do
			Result := True
		end

	try_put_value (a_value: like value; i: INTEGER)
		do
			validate (a_value)
			if not app.has_argument_errors then
				if is_list and then attached {CHAIN [like value]} app.operands.item (i) as list then
					list.extend (a_value)
				else
					put_reference (a_value, i)
				end
			end
		end

	new_list (string_value: ZSTRING): EL_ZSTRING_LIST
		local
			separator: CHARACTER_32
		do
			if is_list then
				separator := ';'
				if not string_value.has (separator) then
					separator := ','
				end
				create Result.make_with_separator (string_value, separator, True)
			else
				create Result.make_from_array (<< string_value >>)
			end
		end

	put_reference (a_value: like value; i: INTEGER)
		do
			app.operands.put_reference (a_value, i)
		end

	set_error (a_value: like value; valid_description: ZSTRING)
		do
			app.argument_errors.extend (argument.new_error)
			app.argument_errors.last.set_invalid_argument (valid_description)
		end

	value (str: ZSTRING): G
		deferred
		end

	validate (a_value: like value)
		do
			across argument.validation as is_valid loop
				if is_valid.item.valid_operands ([a_value]) and then not is_valid.item (a_value) then
					set_error (a_value, is_valid.key)
				end
			end
		end

	value_description: ZSTRING
		local
			type: TYPE [like value]
			name: STRING
		do
			type := {like value}
			name := type.name.as_lower
			if name.starts_with ("el_") then
				name.remove_head (3)
			end
			String_8.replace_character (name, '_', ' ')
			Result := name
		end

	type_description: ZSTRING
		do
			Result := value_description
			if is_list then
				Result.prepend_string_general ("a list of ")
				Result.append_character ('s')
			end
		end

feature {NONE} -- Internal attributes

	app: EL_COMMAND_LINE_SUB_APPLICATION [EL_COMMAND]

	argument: EL_COMMAND_ARGUMENT

	is_list: BOOLEAN

end
