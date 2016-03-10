note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 14:17:00 GMT (Thursday 1st January 2015)"
	revision: "5"

class
	WEB_FORM

inherit
	EL_BUILDABLE_XML_FILE_PERSISTENT
		rename
			make_default as make
		redefine
			make, building_action_table, getter_function_table
		end

	EL_MODULE_LOG

create
	make_from_file, make_from_binary_file, make_from_string, make, make_from_binary_stream

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create component_list.make (7)
		end

feature -- Access

	component_list: ARRAYED_LIST [WEB_FORM_COMPONENT]

	title: STRING

	language: STRING

feature {NONE} -- Element change

	add_drop_down_list
			--
		do
			log.enter ("add_drop_down_list")
			component_list.extend (create {WEB_FORM_DROP_DOWN_LIST}.make)
			set_next_context (component_list.last)
			log.exit
		end

	set_title_from_node
			--
		do
			log.enter ("set_title_from_node")
			title := node.to_string
			log.exit
		end

	set_language_from_node
			--
		do
			log.enter ("set_language_from_node")
			language := node.to_string
			log.exit
		end

	add_text
			--
		do
			log.enter_with_args ("add_text", << node.to_string >>)
			if not node.is_empty then
				component_list.extend (create {WEB_FORM_TEXT}.make (node.to_string))
			end
			log.exit
		end

	add_line_break
			--
		do
			log.enter ("add_line_break")
			component_list.extend (create {WEB_FORM_LINE_BREAK}.make)
			log.exit

		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["title", 				agent: STRING do Result := title end],
				["component_list", 	agent: ITERABLE [WEB_FORM_COMPONENT] do Result := component_list end]
			>>)
		end

feature {NONE} -- Implementation

	building_action_table: like Type_building_actions
			-- Nodes relative to root element: html
		do
			create Result.make (<<
				["@lang", agent set_language_from_node],
				["head/title/text()", agent set_title_from_node],
				["body/select", agent add_drop_down_list],
				["body/text()", agent add_text],
				["body/br", agent add_line_break]
			>>)
		end

	Root_node_name: STRING = "html"

feature {NONE} -- Implementation

	Template: STRING =
		-- Substitution template

		--| Despite appearances the tab level is 0
		--| All leading tabs are removed by Eiffel compiler to match the first line
	"[
		<?xml version="1.0" encoding="$encoding_name"?>
		<?create {WEB_FORM}?>
		<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
			<head>
				<title>$title</title>
			</head>
			<body>
		#if $component_list.count > 0 then	
			#across $component_list as $component loop
				#evaluate ($component.item.template_name, $component.item)
			#end
		#end
			</body>
		</html>
	]"

end
