note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-28 16:43:10 GMT (Friday 28th June 2013)"
	revision: "2"

class
	EL_SUBSTITUTION_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_SUBST_VARIABLE_PARSER
		rename
			make as make_parser,
			set_source_text as set_parser_text,
			match_full as parse_template
		export
			{NONE} all
		undefine
			default_create
		redefine
			parse_template
		end

	EL_MODULE_STRING
		rename
			String as Mod_string
		undefine
			default_create
		end

	STRING_HANDLER
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
			make_parser
			create string.make_empty
			create decomposed_template.make (7)
			create variables.make (5)
			create actual_template.make_empty
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

feature -- Basic operations

	substitute
			-- Concatanate from command text list
		do
			string.set_count (0)
			from decomposed_template.start until decomposed_template.after loop
				string.append (decomposed_template.item)
				decomposed_template.forth
			end
		end

feature -- Status query

	is_variables_table_empty: BOOLEAN
			--
		do
			Result := variables.is_empty
		end

	has_variable (name: READABLE_STRING_GENERAL): BOOLEAN
		local
			variable_name: S
		do
			create variable_name.make_empty
			variable_name.append (name)
			Result:= variables.has (variable_name)
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
			valid_variables: across variable_name_and_value_array as tuple all has_variable (tuple.item.name) end
		do
			across variable_name_and_value_array as tuple loop
				set_variable (tuple.item.name, tuple.item.value)
			end
		end

	set_variable (name: READABLE_STRING_GENERAL; value: ANY)
		require
			valid_variable: has_variable (name)
		local
			variable_not_found_exception: EXCEPTION
			variable_name, place_holder: S
		do
			create variable_name.make_empty
			variable_name.append (name)
			variables.search (variable_name)
			if variables.found then
				place_holder := variables.found_item
				place_holder.set_count (0)
				if attached {READABLE_STRING_GENERAL} value as string_value then
					place_holder.append (string_value)
				else
					place_holder.append (value.out)
				end
			else
				create variable_not_found_exception
				variable_not_found_exception.set_description (
					Mod_string.template ("class {$S}: Variable %"$S%" not found").substituted (<< generator, variable_name >>)
				)
				variable_not_found_exception.raise
			end
		end

	set_template (a_template: S)
			--
		do
			actual_template := a_template
			set_parser_text (actual_template)
			parse_template
		end

feature {NONE} -- Implementation: parsing actions

	on_literal_text (matched_text: EL_STRING_VIEW)
			--
		do
--			log.enter_with_args ("on_literal_text", << matched_text.view >>)
			decomposed_template.extend (matched_text.view_general)
--			log.exit
		end

	on_substitution_variable (matched_text: EL_STRING_VIEW)
			--
		local
			place_holder, variable_name: S
		do
--			log.enter_with_args ("on_substitution_variable", << matched_text.view >>)
			create variable_name.make_empty
			variable_name.append (matched_text.view_general)
			if variables.has (variable_name) then
				place_holder := variables [variable_name]
			else
				create place_holder.make_empty
				variables [variable_name] := place_holder
			end
			decomposed_template.extend (place_holder)
--			log.exit
		end

feature {NONE} -- Implementation

	decomposed_template: ARRAYED_LIST [READABLE_STRING_GENERAL]

	variables: HASH_TABLE [S, S]

	parse_template
			--
		do
			decomposed_template.wipe_out
			Precursor
			if full_match_succeeded then
				consume_events
			end
		ensure then
			valid_command_syntax: full_match_succeeded
		end

	template: S
			--
		do
			Result := actual_template
		end

	actual_template: S

feature {NONE} -- Type definitions

	Type_name_value_pair: TUPLE [name: READABLE_STRING_GENERAL; value: ANY]
		do
		end

end
