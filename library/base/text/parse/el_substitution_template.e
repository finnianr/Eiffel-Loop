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
	date: "2017-08-14 18:46:20 GMT (Monday 14th August 2017)"
	revision: "3"

class
	EL_SUBSTITUTION_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_SUBST_VARIABLE_PARSER
		rename
			set_source_text as set_parser_text
		export
			{NONE} all
		undefine
			default_create
		redefine
			parse, reset
		end

	STRING_HANDLER
		undefine
			default_create
		end

	EL_MODULE_EXCEPTION
		undefine
			default_create
		end

	EL_REFLECTION
		undefine
			default_create
		end

	EL_REFLECTION_HANDLER
		undefine
			default_create
		end

create
	make, default_create

convert
	make ({S})

feature {NONE} -- Initialization

	default_create
			--
		do
			create string.make_empty
			create decomposed_template.make (7)
			create place_holder_table.make (5)
			create actual_template.make_empty
			is_strict := True
			make_default
		end

	make (a_template: S)
			--
		do
			default_create
			set_template (a_template)
		end

feature -- Access

	string: S
		-- substituted string

	substituted: S
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

	set_template (a_template: S)
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
			place_holder: S; name: ZSTRING
		do
			name := from_general (a_name)
			place_holder_table.search (name)
			if place_holder_table.found then
				place_holder := place_holder_table.found_item
				wipe_out (place_holder)
				if attached {READABLE_STRING_GENERAL} value as string_value then
					place_holder.append (string_value)
				else
					place_holder.append (value.out)
				end
			elseif is_strict then
				Exception.raise_developer ("class {%S}: Variable %"%S%" not found", [generator, name])
			end
		end

	set_variable_quoted_value (name, value: READABLE_STRING_GENERAL)
		local
			quoted_value: S
		do
			create quoted_value.make (value.count + 2)
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
			meta_object: like Once_current_object
			i, field_count: INTEGER; name: ZSTRING
		do
			name := Once_name
			meta_object := Once_current_object
			meta_object.set_object (object)
			field_count := meta_object.field_count
			if attached {EL_REFLECTIVELY_SETTABLE [S]} object as l_object then
				across l_object.field_index_table as field loop
					name.wipe_out
					name.append_string_general (field.key)
					if has_variable (name) then
						set_variable (name, meta_object.reference_field (field.item))
					end
				end
			else
				from i := 1 until i > field_count loop
					name.wipe_out
					name.append_string_general (meta_object.field_name (i))
					if has_variable (name) then
						set_variable (name, meta_object.field (i))
					end
					i := i + 1
				end
			end
		end

	reset
		do
			Precursor
			decomposed_template.wipe_out
			place_holder_table.wipe_out
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
			place_holder: S; name: ZSTRING
		do
--			log.enter_with_args ("on_substitution_variable", << matched_text.view >>)

			name := matched_text.to_string
			if place_holder_table.has (name) then
				place_holder := place_holder_table [name]
			else
				-- Initialize value as  $<variable name> to allow successive substitutions
				create place_holder.make (name.count + 1)
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

	template: S
			--
		do
			Result := actual_template
		end

	wipe_out (str: S)
		do
			if attached {BAG [COMPARABLE]} str as characters then
				characters.wipe_out
			end
		end

feature {NONE} -- Internal attributes

	actual_template: S

	decomposed_template: ARRAYED_LIST [READABLE_STRING_GENERAL]

	place_holder_table: HASH_TABLE [S, ZSTRING]
		-- map variable name to place holder

feature {NONE} -- Constants

	Once_name: ZSTRING
		once
			create Result.make_empty
		end

end
