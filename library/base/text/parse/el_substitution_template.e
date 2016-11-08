note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-04 8:13:42 GMT (Tuesday 4th October 2016)"
	revision: "2"

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

	substituted: S
			--
		do
			substitute
			Result := string.twin
		end

	string: S
		-- substituted string

	variables: ARRAYED_LIST [S]
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

	reset
		do
			Precursor
			decomposed_template.wipe_out
			place_holder_table.wipe_out
		end

feature -- Status query

	is_variables_table_empty: BOOLEAN
			--
		do
			Result := place_holder_table.is_empty
		end

	has_variable (name: READABLE_STRING_GENERAL): BOOLEAN
		local
			variable_name: S
		do
			create variable_name.make_empty
			variable_name.append (name)
			Result:= place_holder_table.has (variable_name)
		end

	is_strict: BOOLEAN
		-- when true, enforces precondition that variables exist and raises an exception if a variable is not found

feature -- Status change

	disable_strict
		do
			is_strict := False
		end

feature -- Element change

	set_variable_quoted_value (variable_name, value: READABLE_STRING_GENERAL)
		local
			quoted_value: S
		do
			create quoted_value.make (value.count + 2)
			quoted_value.append_code ({ASCII}.Doublequote.to_natural_32)
			quoted_value.append (value)
			quoted_value.append_code ({ASCII}.Doublequote.to_natural_32)
			set_variable (variable_name, quoted_value)
		end

	set_variables_from_array (variable_name_and_value_array: ARRAY [like Type_name_value_pair])
			--
		require
			valid_variables: is_strict implies across variable_name_and_value_array as tuple all has_variable (tuple.item.name) end
		do
			across variable_name_and_value_array as tuple loop
				set_variable (tuple.item.name, tuple.item.value)
			end
		end

	set_variable (a_name: READABLE_STRING_GENERAL; value: ANY)
		require
			valid_variable: is_strict implies has_variable (a_name)
		local
			variable_name, place_holder: S
		do
			if attached {S} a_name as name then
				variable_name := name
			else
				create variable_name.make_empty
				variable_name.append (a_name)
			end
			place_holder_table.search (variable_name)
			if place_holder_table.found then
				place_holder := place_holder_table.found_item
				wipe_out (place_holder)
				if attached {READABLE_STRING_GENERAL} value as string_value then
					place_holder.append (string_value)
				else
					place_holder.append (value.out)
				end

			elseif is_strict then
				Exception.raise_developer ("class {%S}: Variable %"%S%" not found", [generator, variable_name])
			end
		end

	set_template (a_template: S)
			--
		do
			actual_template := a_template
			set_parser_text (actual_template)
			parse
		end

feature -- Type definitions

	Type_name_value_pair: TUPLE [name: READABLE_STRING_GENERAL; value: ANY]
		once
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
			place_holder, variable_name: S
		do
--			log.enter_with_args ("on_substitution_variable", << matched_text.view >>)
			create variable_name.make_empty
			variable_name.append (matched_text.to_string)
			if place_holder_table.has (variable_name) then
				place_holder := place_holder_table [variable_name]
			else
				-- Initialize value as  $<variable name> to allow successive substitutions
				create place_holder.make (variable_name.count + 1)
				place_holder.append_code (('$').natural_32_code)
				place_holder.append (variable_name)
				place_holder_table [variable_name] := place_holder
			end
			decomposed_template.extend (place_holder)
--			log.exit
		end

feature {NONE} -- Implementation

	wipe_out (str: S)
		do
			if attached {BAG [COMPARABLE]} str as characters then
				characters.wipe_out
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

	decomposed_template: ARRAYED_LIST [READABLE_STRING_GENERAL]

	place_holder_table: HASH_TABLE [S, S]
		-- map variable name to place holder

	actual_template: S

end
