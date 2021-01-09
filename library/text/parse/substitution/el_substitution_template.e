note
	description: "[
		String substitution template with placeholder variables designated by the '$' symbol.
		To differentiate variable names from contiguous text, the variable name can be enclosed by
		curly braces as for example `$code' in the template `"Country: ${code}"'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-09 10:18:25 GMT (Saturday 9th January 2021)"
	revision: "16"

deferred class
	EL_SUBSTITUTION_TEMPLATE

inherit
	EL_SUBST_VARIABLE_PARSER
		rename
			set_source_text as set_parser_text,
			zstring_argument as new_zstring
		export
			{NONE} all
		redefine
			make_default, parse, reset
		end

	EL_MODULE_EXCEPTION

	EL_SHARED_OBJECT_POOL

	EL_REFLECTION_HANDLER

	STRING_HANDLER

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL)
			--
		local
			new_template: like new_string
		do
			make_default
			new_template := new_string (a_template.count)
			new_template.append (a_template)
			set_template (new_template)
		end

	make_default
			--
		do
			internal_key := new_string (0)
			actual_template := new_string (0)

			parts := new_parts (7)
			create place_holder_table.make (5)
			is_strict := True
			Precursor {EL_SUBST_VARIABLE_PARSER}
		end

feature -- Access

	substituted: like new_string
			--
		do
			Result := parts.joined_strings
		end

	variables: ARRAYED_LIST [like new_string]
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

	set_template (a_template: like new_string)
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
			quoted_value: like new_string
		do
			quoted_value := new_string (value.count + 2)
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
				wipe_out (place.item)
			end
		end

feature {NONE} -- Implementation: parsing actions

	on_literal_text (matched_text: EL_STRING_VIEW)
			--
		do
			parts.extend (match_string (matched_text))
		end

	on_substitution_variable (matched_text: EL_STRING_VIEW)
			--
		local
			l_key: like key
		do
			l_key := match_string (matched_text)
			place_holder_table.put (dollor_sign + l_key, l_key)
			parts.extend (place_holder_table.found_item)
		end

feature {NONE} -- Implementation

	dollor_sign: like new_string
		do
			Result := new_string (1)
			Result.append_code ({ASCII}.Dollar.to_natural_32)
		end

	key (str: READABLE_STRING_GENERAL): like new_string
		-- reusable key for `place_holder_table'
		do
			Result := internal_key
			wipe_out (Result)
			append_from_general (Result, str)
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
			place_holder: like new_string
		do
			if place_holder_table.has_key (a_key) then
				place_holder := place_holder_table.found_item
				wipe_out (place_holder)
				if attached {READABLE_STRING_GENERAL} value as string_value then
					append_from_general (place_holder, string_value)
				else
					place_holder.append (value.out)
				end
			end
		end

	template: like new_string
			--
		do
			Result := actual_template
		end

feature {NONE} -- Deferred implementation

	append_from_general (target: like new_string; a_general: READABLE_STRING_GENERAL)
		deferred
		end

	match_string (matched_text: EL_STRING_VIEW): like new_string
		deferred
		end

	new_string (n: INTEGER): STRING_GENERAL
		deferred
		end

	new_parts (n: INTEGER): EL_STRING_LIST [like new_string]
		deferred
		end

	wipe_out (str: like new_string)
		deferred
		end

feature {NONE} -- Internal attributes

	actual_template: like new_string

	parts: like new_parts
		-- substition parts

	place_holder_table: HASH_TABLE [like new_string, like new_string]
		-- map variable name to place holder

	internal_key: like key

feature {NONE} -- Constants

	Meta_data_by_type: HASH_TABLE [EL_CLASS_META_DATA, TYPE [ANY]]
		once
			create Result.make_equal (11)
		end

end