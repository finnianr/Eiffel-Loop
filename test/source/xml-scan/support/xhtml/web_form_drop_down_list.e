note
	description: "Web form drop down list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:23:23 GMT (Sunday 22nd September 2024)"
	revision: "9"

class
	WEB_FORM_DROP_DOWN_LIST

inherit
	WEB_FORM_COMPONENT
		rename
			make_default as make
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create option_list.make (7)
			create name.make_empty
			Precursor
		end

feature -- Access

	option_list: EL_ZSTRING_LIST

	selected_option: INTEGER

	name: STRING

feature {NONE} -- Build from XML

	add_option
			--
		do
			option_list.extend (create {STRING}.make_empty)
			log_extend ("option_list", option_list)
		end

	set_option_text
			--
		do
			if attached option_list.last as last then
				node.set (last)
			end
			log_assignment ("option_list.last", node.to_string)
		end

	set_selected_option
			--
		do
			if node.same_as ("true") then
				selected_option := option_list.count
				log_assignment ("selected_option", option_list.count)
			end
		end

	set_name_from_node
			--
		do
			node.set_8 (name)
			log_assignment ("name", node.to_string_8)
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Relative to nodes /html/body/select
		do
			create Result.make_assignments (<<
				["option", agent add_option],
				["option/text()", agent set_option_text],
				["option/@selected", agent set_selected_option],
				["@name", agent set_name_from_node]
			>>)
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["option_list", agent: ITERABLE [ZSTRING] do Result := option_list end],
				["selected_option", agent: REAL_REF do Result := selected_option.to_real.to_reference end],
				["name", agent: STRING do Result := name end]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING =
		-- Substitution template
	"[
		<select name="$name">
		#foreach $option in $option_list loop
			#if $loop_index = $selected_option then
			<option selected="true">$option</option>
			#else
			<option>$option</option>
			#end
		#end
		</select>
	]"

end