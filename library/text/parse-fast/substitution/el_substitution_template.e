note
	description: "[
		String substitution template with placeholder variables designated by the '$' symbol.
	]"
	notes: "[
		To differentiate variable names from contiguous text, the variable name can be enclosed by
		curly braces as for example `$code' in the template `"Country: ${code}"'

		If you need to have a literal $ sign use class [$source EL_TEMPLATE [STRING_GENERAL]] instead,
		as it supports dollor escaping with the % character.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_SUBSTITUTION_TEMPLATE

inherit
	EL_SUBST_VARIABLE_PARSER
		rename
			set_source_text as set_parser_text
		export
			{NONE} all
		redefine
			make_default, parse, reset, source_text
		end

	EL_MODULE_EXCEPTION

	EL_SHARED_OBJECT_POOL

	EL_REFLECTION_HANDLER

	STRING_HANDLER

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL)
			--
		local
			new_template: like string.new
		do
			make_default
			new_template := string.new (a_template.count)
			new_template.append (a_template)
			set_template (new_template)
		end

	make_default
			--
		do
			internal_key := string.new (0)
			actual_template := string.new (0)

			parts := string.new_list (7)
			create place_holder_table.make (5)
			is_strict := True
			Precursor {EL_SUBST_VARIABLE_PARSER}
		end

feature -- Access

	substituted: like string.new
			--
		do
			Result := parts.joined_strings
		end

	variables: ARRAYED_LIST [like string.new]
			-- variable name list
		do
			create Result.make_from_array (place_holder_table.current_keys)
		end

feature -- Status query

	has_variable (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result:= place_holder_table.has (key (name))
		end

	is_strict: BOOLEAN
		-- when true, enforces precondition that variables exist and raises an exception if a variable is not found

	is_variables_table_empty: BOOLEAN
			--
		do
			Result := place_holder_table.is_empty
		end

feature -- Status change

	disable_strict
		do
			is_strict := False
		end

feature -- Element change

	reset
		do
			Precursor
			parts.wipe_out
			place_holder_table.wipe_out
		end

	set_template (a_template: like string.new)
			--
		do
			actual_template := a_template
			set_parser_text (actual_template)
			parse
		end

	set_variable (a_name: READABLE_STRING_GENERAL; value: ANY)
		require
			valid_variable: is_strict implies has_variable (a_name)
		do
			if is_strict and then not has_variable (a_name) then
				Exception.raise_developer ("class {%S}: Variable %"%S%" not found", [generator, a_name])
			else
				set_place_holder_item (key (a_name), value)
			end
		end

	set_variable_quoted_value (name, value: READABLE_STRING_GENERAL)
		local
			quoted_value: like string.new
		do
			quoted_value := string.new (value.count + 2)
			quoted_value.append_code ({ASCII}.Doublequote.to_natural_32)
			quoted_value.append (value)
			quoted_value.append_code ({ASCII}.Doublequote.to_natural_32)
			set_variable (name, quoted_value)
		end

	set_variables_from_array (nvp_list: ARRAY [TUPLE [name: READABLE_STRING_GENERAL; value: ANY]])
			--
		require
			valid_variables: is_strict implies across nvp_list as tuple all has_variable (tuple.item.name) end
		do
			across nvp_list as tuple loop
				set_variable (tuple.item.name, tuple.item.value)
			end
		end

	set_variables_from_object (object: ANY)
		-- set variables in template that match field names of `object'
		local
			meta_object: like new_current_object; table: EL_REFLECTED_FIELD_TABLE
			i, field_count: INTEGER
		do
			if attached {EL_REFLECTIVE} object as reflective then
				table := reflective.field_table
				from table.start until table.after loop
					set_place_holder_item (key (table.key_for_iteration), table.item_for_iteration.to_string (reflective))
					table.forth
				end
			else
				meta_object := new_current_object (object)
				field_count := meta_object.field_count
				from i := 1 until i > field_count loop
					set_place_holder_item (key (meta_object.field_name (i)), meta_object.field (i))
					i := i + 1
				end
				recycle (meta_object)
			end
		end

	wipe_out_variables
		do
			across place_holder_table as place loop
				string.wipe_out (place.item)
			end
		end

feature {NONE} -- Implementation: parsing actions

	on_literal_text (start_index, end_index: INTEGER)
			--
		do
			parts.extend (source_text.substring (start_index, end_index))
		end

	on_substitution_variable (start_index, end_index: INTEGER)
			--
		local
			l_key: like key
		do
			l_key := source_text.substring (start_index, end_index)
			place_holder_table.put (dollor_sign + l_key, l_key)
			parts.extend (place_holder_table.found_item)
		end

feature {NONE} -- Implementation

	dollor_sign: like string.new
		do
			Result := string.new (1)
			Result.append_code ({ASCII}.Dollar.to_natural_32)
		end

	key (str: READABLE_STRING_GENERAL): like string.new
		-- reusable key for `place_holder_table'
		do
			Result := internal_key
			string.wipe_out (Result)
			string.append_to (Result, str)
		end

	parse
			--
		do
			parts.wipe_out
			Precursor
		ensure then
			valid_command_syntax: fully_matched
		end

	set_place_holder_item (a_key: like key; value: ANY)
		require
			internal_key: a_key = internal_key
		local
			place_holder: like string.new
		do
			if place_holder_table.has_key (a_key) then
				place_holder := place_holder_table.found_item
				string.wipe_out (place_holder)
				if attached {READABLE_STRING_GENERAL} value as string_value then
					string.append_to (place_holder, string_value)
				else
					place_holder.append (value.out)
				end
			end
		end

	template: like string.new
			--
		do
			Result := actual_template
		end

feature {NONE} -- Deferred implementation

	string: EL_STRING_X_ROUTINES [STRING_GENERAL, READABLE_STRING_GENERAL]
		deferred
		end

feature {NONE} -- Internal attributes

	actual_template: like string.new

	internal_key: like key

	parts: like string.new_list
		-- substition parts

	place_holder_table: HASH_TABLE [like string.new, like string.new]
		-- map variable name to place holder

	source_text: like string.new

feature {NONE} -- Constants

	Meta_data_by_type: HASH_TABLE [EL_CLASS_META_DATA, TYPE [ANY]]
		once
			create Result.make_equal (11)
		end

end