note
	description: "Test vtd xml app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 12:21:33 GMT (Friday 31st January 2020)"
	revision: "13"

class
	VTD_XML_TEST_APP

inherit
	TEST_SUB_APPLICATION
		redefine
			Option_name, initialize
		end

	EL_MODULE_EXCEPTION

	EL_MODULE_OS

	EL_MODULE_XML

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			log.enter ("initialize")
--			Console.show ({EL_SPREAD_SHEET_TABLE})
			Precursor
			create root_node
			log.exit
		end

feature -- Basic operations

	test_run
		do
			log.enter ("test_run")
			Test.do_file_test ("vtd-xml/bioinfo.xml", agent query_bioinfo, 2349762920)
--			Test.do_file_test ("vtd-xml/aircraft_power_price.svg", agent query_svg, 2735359820)
--			Test.do_file_test ("vtd-xml/CD-catalog.xml", agent query_cd_catalog, 3937389230)
--			Test.do_all_files_test ("vtd-xml", "request-matrix*.xml", agent query_processing_instruction, 3772593145)
--			Test.do_file_tree_test ("pi-taylor-series", agent pi_taylor_series, 103269780)
			log.exit
		end

feature {NONE} -- Tests

	query_bioinfo (file_path: EL_FILE_PATH)
		do
			log.enter_with_args ("query_bioinfo", [file_path])
			create root_node.make_from_file (file_path)


			log.exit
		end

	query_svg (file_path: EL_FILE_PATH)
		do
			log.enter_with_args ("query_svg", [file_path])
			create root_node.make_from_file (file_path)
			log.put_string_field ("Encoding", root_node.encoding_name)
			log.put_new_line

			do_query_svg_1 ("//svg/g[starts-with (@style, 'stroke:blue')]/line")
			do_query_svg_2 ("//svg/g[starts-with (@style, 'stroke:black')]/line")
			do_query_svg_3 ("sum (//svg/g/line/@x1)")
			do_query_svg_3 ("sum (//svg/g/line/@y1)")

			log.exit
		end

	query_cd_catalog (file_path: EL_FILE_PATH)
		do
			log.enter_with_args ("query_cd_catalog", [file_path])
			create root_node.make_from_file (file_path)
			log.put_string_field ("Encoding", root_node.encoding_name)
			log.put_new_line

			do_cd_catalog_query ("count (CONTENTS/TRACK[contains (lower-case (text()),'blues')]) > 0")
			do_cd_catalog_query ("ARTIST [text() = 'Bob Dylan']")
			do_cd_catalog_query ("number (substring (PRICE, 2)) < 10")
			do_cd_catalog_query ("number (substring (PRICE, 2)) > 10")

			log.exit
		end

	query_processing_instruction (file_path: EL_FILE_PATH)
			--
		do
			log.enter_with_args ("query_processing_instruction", [file_path])

			create root_node.make_from_file (file_path)
			log.put_string_field ("Encoding", root_node.encoding_name)
			log.put_new_line

			root_node.find_instruction ("call")
			if root_node.instruction_found then
				log.put_string_field ("call", root_node.found_instruction)
			else
				log.put_string_field ("No such instruction", "call")
			end
			log.put_new_line
			log.exit
		end

	pi_taylor_series (a_dir_path: EL_DIR_PATH)
			-- This is a heavy duty test
		local
			file_path: EL_FILE_PATH; file_out: PLAIN_TEXT_FILE
			pi, pi2, limit, term: DOUBLE; numerator, divisor, doc_number: INTEGER
			document_nodes: like taylor_series_document_nodes
		do
			log.enter ("pi_taylor_series")
			numerator := 4; divisor := 1; limit := 0.5E-6
			from term := numerator until term.abs < limit loop
				if divisor \\ 10000 = 1 then
					if divisor > 1 then
						file_out.put_new_line; file_out.put_string ("</pi-series>")
						file_out.close
					end
					file_path := a_dir_path + "pi"
					doc_number := doc_number + 1
					file_path.add_extension (Format.formatted (doc_number))
					file_path.add_extension ("xml")
					log.put_path_field ("Writing", file_path)
					log.put_new_line
					create file_out.make_open_write (file_path)
					file_out.put_string (Pi_series_xml)
				end
				Term_xml_template.set_variable ("numerator", numerator)
				Term_xml_template.set_variable ("divisor", divisor)
				file_out.put_new_line
				file_out.put_string (Term_xml_template.substituted)

				pi := pi + term
				numerator := numerator.opposite
				divisor := divisor + 2
				term := numerator / divisor
			end

			if not file_out.is_closed then
				file_out.put_new_line; file_out.put_string ("</pi-series>")
				file_out.close
			end
			log.put_new_line

			document_nodes := taylor_series_document_nodes (a_dir_path)
			from document_nodes.start until document_nodes.is_empty loop
				across document_nodes.item.context_list (Xpath_pi_series_term) as doc_term loop
					numerator := doc_term.node.integer_at_xpath (Xpath_numerator)
					divisor := doc_term.node.integer_at_xpath (Xpath_divisor)
					pi2 := pi2 + numerator / divisor
				end
				document_nodes.remove
			end
			log.put_new_line
			log.put_double_field ("Pi 1", pi)
			log.put_new_line
			log.put_double_field ("Pi 2", pi2)
			log.put_new_line
			log.exit
		end

feature {NONE} -- Implementation

	do_query_svg_1 (xpath: STRING)
			-- distance double coords
		local
			p1, p2: SVG_POINT
		do
			log.enter_with_args ("do_query_svg_1", [xpath])
			across root_node.context_list (xpath) as line loop
				create p1.make (line.node.attributes, 1)
				create p2.make (line.node.attributes, 2)
				log.put_double_field ("line length", p1.distance (p2))
				log.put_new_line
			end
			log.exit
		end

	do_query_svg_2 (xpath: STRING)
			-- distance integer coords
		local
			line_node_list: EL_XPATH_NODE_CONTEXT_LIST
			p1, p2: SVG_INTEGER_POINT
		do
			log.enter_with_args ("do_query_svg_2", [xpath])
			across root_node.context_list (xpath) as line loop
				create p1.make (line.node.attributes, 1)
				create p2.make (line.node.attributes, 2)
				log.put_double_field ("line length", p1.distance (p2))
				log.put_new_line
			end
			log.exit
		end

	do_query_svg_3 (xpath: STRING)
			--
		do
			log.enter_with_args ("do_query_svg_3", [xpath])
			log.put_double_field (xpath, root_node.double_at_xpath (xpath))
			log.put_new_line
			log.exit
		end

	do_cd_catalog_query (criteria: STRING)
		local
			xpath: STRING; template: ZSTRING
		do
			log.enter_with_args ("do_query_cd_catalog", [criteria])
			template := once "/CATALOG/CD[%S]"
			xpath := template #$ [criteria]

			across root_node.context_list (xpath) as cd loop
				lio.put_string_field ("ALBUM", cd.node.string_at_xpath ("TITLE"))
				lio.put_new_line
				lio.put_string_field ("ARTIST", cd.node.string_at_xpath ("ARTIST"))
				lio.put_new_line
				lio.put_string_field ("PRICE", cd.node.string_at_xpath ("PRICE"))
				lio.put_new_line
				across cd.node.context_list ("CONTENTS/TRACK") as track loop
					lio.put_string ("    " + track.cursor_index.out + ". ")
					lio.put_line (track.node.string_value)
				end
				lio.put_new_line
			end
			log.exit
		end

	taylor_series_document_nodes (a_dir_path: EL_DIR_PATH): LINKED_LIST [EL_XPATH_ROOT_NODE_CONTEXT]
		do
			create Result.make
			across OS.file_list (a_dir_path, "*.xml") as file_path loop
				log.put_path_field ("Parsing", file_path.item)
				log.put_new_line
				Result.extend (create {EL_XPATH_ROOT_NODE_CONTEXT}.make_from_file (file_path.item))
			end
		end

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

feature {NONE} -- Constants

	Option_name: STRING = "test_vtd_xml"

	Description: STRING = "Test Virtual Token Descriptor xml parser"

	Pi_series_xml: STRING =
		--
	"[
		<?xml version="1.0" encoding="UTF-8"?>
		<pi-series>
	]"

	Term_xml_template: EL_STRING_8_TEMPLATE
		once
			Result := "[
				<term>
					<numerator>$numerator</numerator>
					<divisor>$divisor</divisor>
				</term>
			]"
		end

	Format: FORMAT_INTEGER
		once
			create Result.make (5)
			Result.zero_fill
		end

	Xpath_pi_series_term: STRING_32 = "/pi-series/term"

	Xpath_numerator: STRING_32 = "numerator"

	Xpath_divisor: STRING_32 = "divisor"

end
