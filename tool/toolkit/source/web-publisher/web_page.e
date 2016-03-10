note
	description: "Summary description for {WEB_PAGE_GENERATOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:38:10 GMT (Monday 24th June 2013)"
	revision: "2"

class
	WEB_PAGE

inherit
	EVOLICITY_EIFFEL_CONTEXT

	PART_COMPARABLE

	EL_MODULE_STRING

	EL_MODULE_LOG

	EL_MODULE_EVOLICITY_ENGINE

create
	make

feature {NONE} -- Initialization

	make (a_config: like config; file_path: EL_FILE_PATH)
			--
		local
			properties: WEB_PAGE_PROPERTIES
			value: STRING
		do
			log.enter_with_args ("make", << file_path >>)
			make_eiffel_context
			create menu.make
			content_path := file_path
			config := a_config
			output_path := config.web_root_dir + file_path.base
			print_view_output_path := output_path.with_new_extension ("p.html")

			create properties.make_from_file (content_path)

			keywords := properties.string_at_xpath ("/html/body/@keywords")
			description := properties.string_at_xpath ("/html/body/@description")
			menu_name := properties.string_at_xpath ("/html/body/@menu_name")
			page_title := properties.string_at_xpath ("/html/head/title")

			log_or_io.put_string_field ("PAGE TITLE", page_title)
			log_or_io.put_new_line
			log_or_io.put_string_field ("DESCRIPTION", description)
			log_or_io.put_new_line
			log_or_io.put_string_field ("MENU NAME", menu_name)
			log_or_io.put_new_line
			log_or_io.put_string_field ("BASENAME", output_path.base)
			log_or_io.put_new_line
			log_or_io.put_new_line

			value := properties.string_at_xpath ("/html/body/@has_print_view")
			if value.is_boolean then
				has_print_view := value.to_boolean
			end

			create content.make_from_file (content_path)
			log.exit
		end

feature -- Access

	keywords: STRING

	description: STRING

	page_title: STRING

	menu_name: STRING

feature -- Status report

	has_contents: BOOLEAN

	has_print_view: BOOLEAN

	is_print_view: BOOLEAN

feature -- Basic operations

	publish
			-- publish generated page
		do
			log.enter ("publish")
			has_contents := content.has_contents

			is_print_view := False
			Evolicity_engine.set_horrible_indentation
			log_or_io.put_path_field ("Writing", output_path)
			log_or_io.put_new_line
			Evolicity_engine.merge_to_file (config.default_template, Current, output_path)

			if has_print_view then
				is_print_view := True
				has_print_view := False
				log_or_io.put_path_field ("Writing", print_view_output_path)
				log_or_io.put_new_line
				Evolicity_engine.merge_to_file (config.default_template, Current, print_view_output_path)

				is_print_view := False
				has_print_view := True
			end
			Evolicity_engine.set_nice_indentation
			log.exit
		end

feature -- Element change

	set_menu (a_menu: like menu)
			--
		do
			create menu.make
			a_menu.do_if (agent menu.extend, agent not_this_current_web_page)
		end


feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := menu_name < other.menu_name
		end

feature {NONE} -- Implementation

	not_this_current_web_page (page: WEB_PAGE): BOOLEAN
			--
		do
			Result := page /= Current
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["keywords", 					agent: STRING do Result := keywords end],
				["description", 				agent: STRING do Result := description end],
				["page_title", 				agent: STRING do Result := page_title end],
				["menu_name", 					agent: STRING do Result := menu_name end],
				["content_path", 				agent: STRING do Result := content.file_path.to_string end],
				["has_contents", 				agent: BOOLEAN_REF do Result := has_contents.to_reference end],
				["has_print_view", 			agent: BOOLEAN_REF do Result := has_print_view.to_reference end],
				["is_print_view", 			agent: BOOLEAN_REF do Result := is_print_view.to_reference end],
				["print_view_href_name", 	agent: STRING do Result := print_view_output_path.base end],
				["href_name", 					agent: STRING do Result := output_path.base end],
				["menu", 						agent: ITERABLE [WEB_PAGE] do Result := menu end]
			>>)
		end

feature {NONE} -- Implementation: attributes

	config: WEB_PUBLISHER_CONFIG

	content: WEB_PAGE_CONTENT

	content_path: EL_FILE_PATH

	output_path: EL_FILE_PATH

	print_view_output_path: EL_FILE_PATH

	menu: PART_SORTED_TWO_WAY_LIST [WEB_PAGE]


end
