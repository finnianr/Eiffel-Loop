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
	date: "2017-12-28 15:57:18 GMT (Thursday 28th December 2017)"
	revision: "9"

deferred class
	EL_SUBSTITUTION_TEMPLATE

inherit
	EL_SUBST_VARIABLE_PARSER
		rename
			empty_string as empty_zstring,
			set_source_text as set_parser_text,
			new_string as new_zstring
		export
			{NONE} all
		redefine
			make_default, parse, reset
		end

	EL_MODULE_EXCEPTION

	EL_SHARED_OBJECT_POOL

	STRING_HANDLER

	EL_REFLECTION_HANDLER

feature {NONE} -- Initialization

	make (a_template: like new_string)
			--
		do
			make_default
			set_template (a_template)
		end

	make_default
			--
		do
			string := new_string (0)
			actual_template := empty_string

			create decomposed_template.make (7)
			create place_holder_table.make (5)
			is_strict := True
			Precursor {EL_SUBST_VARIABLE_PARSER}
		end

feature -- Access

	string: like new_string
		-- substituted string

	substituted: like new_string
			--
		do
			substitute
			Result := string.twin
		end

	variables: ARRAYED_LIST [ZSTRING]
			-- variable name list
		do
			create Result.make_from_array (place_holder_table.current_keys)
		end

feature -- Basic operations

	substitute
			-- Concatanate from command text list
		do
			wipe_out (string)
			from decomposed_template.start until decomposed_template.after loop
				string.append (decomposed_template.item)
				decomposed_template.forth
			end
		end

feature -- Status query

	has_variable (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result:= place_holder_table.has (from_general (name))
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
			decomposed_template.wipe_out
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
		local
			place_holder: like new_string; name: ZSTRING
		do
			name := from_general (a_name)
			place_holder_table.search (name)
			if place_holder_table.found then
				place_holder := place_holder_table.found_item
				wipe_out (place_holder)
				if attached {READABLE_STRING_GENERAL} value as string_value then
					append_from_general (place_holder, string_value)
				else
					place_holder.append (value.out)
				end
			elseif is_strict then
				Exception.raise_developer ("class {%S}: Variable %"%S%" not found", [generator, name])
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

	set_variables_from_array (nvp_array: like NAME_VALUE_PAIR_ARRAY)
			--
		require
			valid_variables: is_strict implies across nvp_array as tuple all has_variable (tuple.item.name) end
		do
			across nvp_array as tuple loop
				set_variable (tuple.item.name, tuple.item.value)
			end
		end

	set_variables_from_object (object: ANY)
		-- set variables in template that match field names of `object'
		local
			meta_object: like new_current_object; table: EL_REFLECTED_FIELD_TABLE
			i, field_count: INTEGER; name: ZSTRING
		do
			name := Once_name
			if attached {EL_REFLECTIVELY_SETTABLE} object as reflective then
				table := reflective.field_table
				from table.start until table.after loop
					name.wipe_out
					name.append_string_general (table.key_for_iteration)
					if has_variable (name) then
						set_variable (name, table.item_for_iteration.to_string (reflective))
					end
					table.forth
				end
			else
				meta_object := new_current_object (object)
				field_count := meta_object.field_count
				from i := 1 until i > field_count loop
					name.wipe_out
					name.append_string_general (meta_object.field_name (i))
					if has_variable (name) then
						set_variable (name, meta_object.field (i))
					end
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

feature -- Type definitions

	NAME_VALUE_PAIR_ARRAY: ARRAY [TUPLE [name: READABLE_STRING_GENERAL; value: ANY]]
		once
			create Result.make_empty
		end

feature {NONE} -- Implementation: parsing actions

	on_literal_text (matched_text: EL_STRING_VIEW)
			--
		do
--			log.enter_with_args ("on_literal_text", << matched_text.view >>)
			decomposed_template.extend (matched_text.to_string)
--			log.exit
		end

	on_substitution_variable (matched_text: EL_STRING_VIEW)
			--
		local
			place_holder: like new_string; name: ZSTRING
		do
--			log.enter_with_args ("on_substitution_variable", << matched_text.view >>)

			name := matched_text.to_string
			if place_holder_table.has (name) then
				place_holder := place_holder_table [name]
			else
				-- Initialize value as  $<variable name> to allow successive substitutions
				place_holder := new_string (name.count + 1)
				place_holder.append_code (('$').natural_32_code)
				if attached {ZSTRING} place_holder as z_place_holder then
					z_place_holder.append (name)
				else
					place_holder.append (name.to_string_32)
				end

				place_holder_table [name] := place_holder
			end
			decomposed_template.extend (place_holder)
--			log.exit
		end

feature {NONE} -- Implementation

	append_from_general (target: like new_string; general: READABLE_STRING_GENERAL)
		deferred
		end

	empty_string: STRING_GENERAL
		deferred
		end

	new_string (n: INTEGER): STRING_GENERAL
		deferred
		end

	from_general (a_str: READABLE_STRING_GENERAL): ZSTRING
		do
			if attached {ZSTRING} a_str as zstr then
				Result := zstr
			else
				Result := Once_name
				Result.wipe_out
				Result.append_string_general (a_str)
			end
		end

	parse
			--
		do
			decomposed_template.wipe_out
			Precursor
		ensure then
			valid_command_syntax: fully_matched
		end

	template: like new_string
			--
		do
			Result := actual_template
		end

	wipe_out (str: like new_string)
		deferred
		end

feature {NONE} -- Internal attributes

	actual_template: like new_string

	decomposed_template: ARRAYED_LIST [READABLE_STRING_GENERAL]

	place_holder_table: HASH_TABLE [like new_string, ZSTRING]
		-- map variable name to place holder

feature {NONE} -- Constants

	Once_name: ZSTRING
		once
			create Result.make_empty
		end

end
