note
	description: "[
		String substitution template with placeholder variables designated by the '$' symbol.
	]"
	notes: "[
		To differentiate variable names from contiguous text, the variable name can be enclosed by
		curly braces as for example `$code' in the template `"Country: ${code}"'

		If you need to have a literal $ sign use class ${EL_TEMPLATE [STRING_GENERAL]} instead,
		as it supports dollor escaping with the % character.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-26 7:30:10 GMT (Wednesday 26th March 2025)"
	revision: "11"

class
	EL_SUBSTITUTION_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_TEMPLATE_LIST [S, READABLE_STRING_GENERAL]

	EL_SUBST_VARIABLE_PARSER
		rename
			set_source_text as set_parser_text,
			name_list as pattern_name_list,
			reset as parser_reset
		export
			{NONE} all
		undefine
			copy, is_equal
		redefine
			make_default, parser_reset, default_source_text
		end

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL)
			--
		do
			make_default
			set_template (a_template)
		end

	make_default
			--
		do
			create internal_key.make_empty
			make_list (7)
			create actual_template.make_empty
			create place_holder_table.make (5)
			Precursor {EL_SUBST_VARIABLE_PARSER}
		end

feature -- Access

	name_list: EL_ARRAYED_LIST [S]
		-- variable name list
		do
			Result := place_holder_table.key_list
		end

feature -- Status query

	has (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result:= place_holder_table.has (key (name))
		end

	no_variables: BOOLEAN
		--
		do
			Result := place_holder_table.is_empty
		end

feature -- Element change

	set_template (a_template: READABLE_STRING_GENERAL)
			--
		do
			actual_template.keep_head (0)
			actual_template.append (a_template)
			set_parser_text (actual_template)
			parse
		ensure
			valid_syntax: fully_matched
		end

	set_empty_variables
		do
			across place_holder_table as place loop
				place.item.keep_head (0)
			end
		end

feature {NONE} -- Parsing events

	on_literal_text (start_index, end_index: INTEGER)
			--
		do
			if attached {S} source_text.substring (start_index, end_index) as str then
				extend (str)
			end
		end

	on_substitution_variable (start_index, end_index: INTEGER)
			--
		local
			variable_ref: READABLE_STRING_GENERAL; place_holder, l_key: S
		do
			l_key := key (source_text.substring (start_index, end_index))
			if place_holder_table.has_key (l_key) then
				place_holder := place_holder_table.found_item
			else
				if source_text [start_index - 1] = '{' then
					variable_ref := source_text.substring (start_index - 2, end_index + 1)
				else
					variable_ref := source_text.substring (start_index - 1, end_index)
				end
				if attached {S} variable_ref as str then
					place_holder := str
				end
				place_holder_table.extend (place_holder, l_key.twin)
			end
			extend (place_holder)
		end

feature {NONE} -- Implementation

	default_source_text: READABLE_STRING_GENERAL
		local
			str: S
		do
			create str.make_empty
			Result := str
		end

	field_key (name: READABLE_STRING_8): S
		do
			Result := key (name)
		end

	found_item (name: READABLE_STRING_GENERAL): detachable S
		do
			if place_holder_table.has_key (key (name)) then
				Result := place_holder_table.found_item
			end
		end

	key (str: READABLE_STRING_GENERAL): S
		-- reusable key for `place_holder_table'
		do
			if str.same_type (internal_key) and then attached {S} str as l_key then
				Result := l_key
			else
				Result := internal_key
				Result.keep_head (0)
				Result.append (str)
			end
		end

	parser_reset
		do
			Precursor
			wipe_out
			place_holder_table.wipe_out
		end

	template: like actual_template
			--
		do
			Result := actual_template
		end

feature {NONE} -- Internal attributes

	actual_template: S

	internal_key: like key

	place_holder_table: EL_HASH_TABLE [S, like key]
		-- map variable name to place holder

end