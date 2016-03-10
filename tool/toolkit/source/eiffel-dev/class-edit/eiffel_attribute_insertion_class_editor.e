note
	description: "Summary description for {EIFFEL_ATTRIBUTE_INSERTION_CLASS_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-10-06 17:32:41 GMT (Monday 6th October 2014)"
	revision: "5"

class
	EIFFEL_ATTRIBUTE_INSERTION_CLASS_EDITOR

inherit
	EL_EIFFEL_TEXT_FILE_EDITOR

	EL_EIFFEL_PATTERN_FACTORY

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make (insertion_marker_list: ARRAYED_LIST [STRING]; new_attribute_name, new_attribute_type: STRING)
			--
		local
			pattern_array: ARRAYED_LIST [EL_LITERAL_TEXTUAL_PATTERN]
			insert_element_change_found: BOOLEAN
			insert_access_index: INTEGER
			insertion_marker_pattern: EL_LITERAL_TEXTUAL_PATTERN
		do
			make_default
			create pattern_array.make (insertion_marker_list.count)
			insertion_marker_list.compare_objects

			from insertion_marker_list.start until insertion_marker_list.after loop
				create insertion_marker_pattern.make_from_string (insertion_marker_list.item)

				if insertion_marker_list.item ~ "${insert_access}" then
					insertion_marker_pattern.set_action_on_match (agent on_insert_access (?, new_attribute_name, new_attribute_type, false))
					insert_access_index := pattern_array.count

				elseif insertion_marker_list.item ~ "${insert_element_change}" then
					insertion_marker_pattern.set_action_on_match (agent on_insert_element_change (?, new_attribute_name))
					insert_element_change_found := true

				else
					insertion_marker_pattern.set_action_on_match (agent replace (?, ""))

				end
				pattern_array.extend (insertion_marker_pattern)
				insertion_marker_list.forth
			end
			if not insert_element_change_found then
				pattern_array.i_th (insert_access_index).set_action_on_match (
					agent on_insert_access (?, new_attribute_name, new_attribute_type, true)
				)
			end

			create delimiting_pattern.make (pattern_array.to_array)
		end

feature {NONE} -- Pattern definitions

	delimiting_pattern: EL_FIRST_MATCH_IN_LIST_TP

feature {NONE} -- Parsing actions

	on_insert_access (text: EL_STRING_VIEW; new_attribute_name, new_attribute_type: STRING; add_feature_element_change: BOOLEAN)
			--
		do
			put_string ("%T" + new_attribute_name + new_attribute_type)
			put_new_line
			put_new_line
			if add_feature_element_change then
				put_string ("feature -- Element change")
				put_new_line
				put_new_line
				on_insert_element_change (text, new_attribute_name)
			end
		end

	on_insert_element_change (text: EL_STRING_VIEW; new_attribute_name: STRING)
			--
		local
			template: EL_SUBSTITUTION_TEMPLATE [STRING]
		do
			create template.make (Attribute_setter_code_template)
			template.set_variable ("attribute_name", new_attribute_name)
			put_string ("%T")
			put_string (template.substituted)
			put_new_line
			put_new_line
		end

feature -- Constant

	Attribute_setter_code_template: STRING =
			--
		"{
	set_$attribute_name (a_$attribute_name: like $attribute_name) is
			-- 
		do
			$attribute_name := a_$attribute_name	
		end

		}"

end
