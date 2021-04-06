note
	description: "Compare XML parsing on small documents"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-06 9:33:36 GMT (Tuesday 6th April 2021)"
	revision: "2"

class
	XML_PARSING_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Basic operations

	execute
		local
			xml: TAYLOR_SERIES_AS_XML
		do
			create xml.make (Work_area_dir)
			xml.generate
			compare ("compare_xml_parsing", 1, <<
				["parse_with_vtd_xml", 	agent parse_with_vtd_xml (xml.path_list)]
			>>)
			xml.cleanup
		end

feature {NONE} -- Implementation

	parse_with_vtd_xml (xml_path_list: EL_FILE_PATH_LIST)
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
			numerator, divisor: INTEGER; pi: DOUBLE
		do
			across xml_path_list as path loop
				create root_node.make_from_file (path.item)
				across root_node.context_list (Xpath_pi_series_term) as doc_term loop
					numerator := doc_term.node.integer_at_xpath (Xpath_numerator)
					divisor := doc_term.node.integer_at_xpath (Xpath_divisor)
					pi := pi + numerator / divisor
				end
			end
		end

feature {NONE} -- Constants

	Work_area_dir: EL_DIR_PATH
		once
			Result := "workarea"
		end

	Xpath_pi_series_term: STRING = "/pi-series/term"

	Xpath_numerator: STRING = "numerator"

	Xpath_divisor: STRING = "divisor"
end