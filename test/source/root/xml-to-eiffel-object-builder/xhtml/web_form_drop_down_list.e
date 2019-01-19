note
	description: "Web form drop down list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-18 12:42:32 GMT (Friday 18th January 2019)"
	revision: "4"

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
			Precursor
		end

feature -- Access

	option_list: ARRAYED_LIST [ZSTRING]

	selected_option: INTEGER

	name: STRING

feature {NONE} -- Build from XML

	add_option
			--
		do
			log.enter ("add_option")
			log.put_line (node.to_string)
			option_list.extend (create {STRING}.make_empty)
			log.exit
		end

	set_option_text
			--
		do
			log.enter ("set_option_text")
			log.put_line (node.to_string)
			option_list.last.share (node.to_string)
			log.exit
		end

	set_selected_option
			--
		do
			log.enter ("set_selected_option")
			if node.is_content_equal ("true") then
				selected_option := option_list.count
			end
			log.exit
		end

	set_name_from_node
			--
		do
			log.enter ("set_name_from_node")
			name := node.to_string
			log.exit
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Relative to nodes /html/body/select
		do
			create Result.make (<<
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
			create Result.make (<<
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
