note
	description: "Object to query command line arguments. Accessible via ${EL_MODULE_ARGS}"
	notes: "[
		As of June 2022 it can now parse options with the form `-name=value' as an alternative to `-name value'.
		This is useful in the case of a value being mistaken for an option if it starts with '-'. In that case you 
		would put: `-name="-not_an_option"'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 19:01:24 GMT (Tuesday 8th April 2025)"
	revision: "30"

class
	EL_COMMAND_LINE_ARGUMENTS

inherit
	ARGUMENTS_32
		rename
			i_th_argument_string as i_th_argument,
			option_sign as option_sign_cell
		export
			{NONE} all
			{ANY} argument_count, new_cursor
		end

	EL_REFLECTION_HANDLER

	EL_CHARACTER_32_CONSTANTS

	EL_SHARED_IMMUTABLE_32_MANAGER

create
	make, make_default, make_latin_1

feature {NONE} -- Initialization

	make (a_command_path: FILE_PATH; a_argument: ARRAY [IMMUTABLE_STRING_32])
		local
			i, equals_index, i_upper, start_index, end_index: INTEGER
			item, name: ZSTRING; i_th_arg: IMMUTABLE_STRING_32
			sg: EL_STRING_GENERAL_ROUTINES
		do
			command_path := a_command_path
			option_sign := option_sign_cell.item
			i_upper := argument_count
			create values_table.make_equal ((i_upper // 2).max (1))
			create name.make_empty
			from i := 1 until i > a_argument.upper loop
				i_th_arg := a_argument [i]
				if sg.super_readable_32 (i_th_arg).starts_with_character (option_sign) then
					equals_index := i_th_arg.index_of ('=', 1)
					start_index := 2
					if equals_index > 0 then
						end_index := equals_index - 1
					else
						end_index := i_th_arg.count
					end
					name := i_th_arg.shared_substring (start_index, end_index)
					if name.count > 0 and then name.is_code_identifier then
						if equals_index > 2 then
							create item.make_from_substring (i_th_arg, equals_index + 1, i_th_arg.count)
							values_table.extend (name, item)
						else
							values_table.extend_area (Empty_area, name)
						end
					else
						extend_values (name, i_th_arg)
					end
				else
					extend_values (name, i_th_arg)
				end
				i := i + 1
			end
			option_list := values_table.key_list
		end

	make_default
		do
			make (i_th_argument (0), new_argument_list.to_array)
		end

	make_latin_1 (a_command_path: FILE_PATH; a_argument: ARRAY [STRING_8])
		local
			l_argument_list: EL_ARRAYED_LIST [IMMUTABLE_STRING_32]
		do
			create l_argument_list.make_filled (a_argument.count, agent to_immutable_32 (a_argument, ?))
			make (a_command_path, l_argument_list.to_array)
		end

feature -- Access

	command_path: FILE_PATH

	directory_path (name: READABLE_STRING_GENERAL): DIR_PATH
		require
			has_value: has_value (name)
		do
			Result := value (name)
		end

	file_path (name: READABLE_STRING_GENERAL): FILE_PATH
		require
			has_value: has_value (name)
		do
			Result := value (name)
		end

	file_path_list (name: READABLE_STRING_GENERAL): EL_FILE_PATH_LIST
		do
			if attached value_list (name) as string_list then
				create Result.make (string_list.count)
				across string_list as list loop
					Result.extend (list.item)
				end
			end
		end

	i_th (index: INTEGER): ZSTRING
		require
			valid_index: valid_index (index)
		do
			create Result.make_from_string (argument (index))
		end

	integer (name: READABLE_STRING_GENERAL): INTEGER
		require
			integer_value_exists: has_integer (name)
		do
			if attached value_area (name) as area and then area.count > 0 then
				Result := area [0].to_integer
			end
		end

	option_list: EL_ARRAYED_LIST [ZSTRING]

	option_name (index: INTEGER): ZSTRING
		require
			valid_index: option_list.valid_index (index)
		do
			if option_list.valid_index (index) then
				Result := option_list [index]
			else
				create Result.make_empty
			end
		end

	value (name: READABLE_STRING_GENERAL): ZSTRING
			-- string value of name value pair arguments
		require
			has_value: has_value (name)
		do
			if attached value_area (name) as area and then area.count > 0 then
				Result := area [0]
			else
				create Result.make_empty
			end
		end

	value_list (name: READABLE_STRING_GENERAL): EL_ZSTRING_LIST
		do
			if attached value_area (name) as area and then area.count > 0 then
				create Result.make_from_special (area)
			end
		end

feature -- Status query

	has_integer (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached value_area (name) as area and then area.count > 0 then
				Result := area [0].is_integer
			end
		end

	has_value (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached value_area (name) as area then
				Result := area.count > 0
			end
		end

	is_value_list (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached value_area (name) as area then
				Result := area.count > 1
			end
		end

	valid_index (index: INTEGER): BOOLEAN
		do
			Result := 0 <= index and index <= argument_count
		end

	option_exists (name: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := values_table.has (z_key (name))
		end

	short_option_exists (option: CHARACTER_32): BOOLEAN
			--
		do
			Result := option_exists (char (option))
		end

feature -- Basic operations

	set_attributes (object: EL_REFLECTIVE)
		-- set attribute in object that match command command options
		do
			across object.field_table as table loop
				if values_table.has_key (z_key (table.key)) and attached values_table.found_area as area then
					if area.count > 0 then
						table.item.set_from_string (object, area [0])

					elseif attached {EL_REFLECTED_BOOLEAN} table.item as boolean then
						boolean.set (object, True)

					elseif attached {EL_REFLECTED_BOOLEAN_REF} table.item as boolean then
						boolean.set_from_integer (object, 1)
					end
				end
			end
		end

feature {NONE} -- Implementation

	extend_values (name: ZSTRING; i_th_arg: IMMUTABLE_STRING_32)
		do
			values_table.extend (name, create {ZSTRING}.make_from_string (i_th_arg))
		end

	new_argument_list: EL_ARRAYED_LIST [IMMUTABLE_STRING_32]
		-- Array containing all arguments after command path
		do
			create Result.make_filled (argument_count, agent i_th_argument)
		end

	to_immutable_32 (a_argument: ARRAY [STRING_8]; i: INTEGER): IMMUTABLE_STRING_32
		do
			Result := a_argument [i]
		end

	value_area (name: READABLE_STRING_GENERAL): like Empty_area
		do
			if values_table.has_key (z_key (name)) then
				Result := values_table.found_area
			else
				Result := Empty_area
			end
		end

	z_key (name: READABLE_STRING_GENERAL): ZSTRING
		local
			buffer: EL_ZSTRING_BUFFER_ROUTINES
		do
			Result := buffer.to_same (name)
		end

feature {NONE} -- Internal attributes

	option_sign: CHARACTER_32

	values_table: EL_GROUPED_LIST_TABLE [ZSTRING, ZSTRING]

feature {NONE} -- Constants

	Empty_area: SPECIAL [ZSTRING]
		once ("PROCESS")
			create Result.make_empty (0)
		end

end