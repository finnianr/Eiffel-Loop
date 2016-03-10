note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-15 8:29:26 GMT (Monday 15th July 2013)"
	revision: "3"

class
	TEST_VTD_XML_APP

inherit
	TEST_APPLICATION
		redefine
			Option_name, initialize
		end

	EXCEPTIONS

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			log.enter ("initialize")
			Precursor
			bio_file_name := "vtd-xml/bioinfo.xml"
			create bio_info_root_node.make_from_file (bio_file_name)
			log.put_string_field ("Encoding bioinfo", bio_info_root_node.encoding_name)
			log.put_new_line

			svg_file_name := "vtd-xml/aircraft_power_price.svg"
			create aircraft_power_price_svg_root_node.make_from_file (svg_file_name)
			log.exit
		end

feature -- Basic operations

	run
		do
			log.enter ("run")
			log.set_timer
			test_spreadsheet
--			test_bio_4 ("Element count", "//*")
			log.put_elapsed_time
			log.exit
		end

	run_X
			--
		do
			-- Select labels followed by exactly two value elements.
			test_bio_1 ("//par/label[count (following-sibling::value) = 2]")
			test_bio_1 ("//par/label[count (following-sibling::value [@type = 'intRange']) = 2]")

			test_bio_2 ("//label[contains (text(), 'branches')]")
			test_bio_2 ("//value[@type='url' and contains (text(), 'http://')]")
			test_bio_2 ("//value[@type='url']/text()")
				-- Gives the same result with or without "/text()".

			test_bio_3 ("//value[@type='integer']") -- This causes a problem somehow ????
			test_bio_3 ("//value[@type='integer' and number (text ()) > 100]")

			test_bio_4 ("Element count", "//*")
			test_bio_4 ("Package count", "//package")
			test_bio_4 ("Command count", "//command")
			test_bio_4 ("Title count", "//value[@type='title']")

			test_bio_5 (
				"URL (strasbg.fr)",
				"//value[@type='url' and starts-with (text(), 'http://') and contains (text(), 'strasbg.fr')]/text()"
			)
			test_bio_5 (
				"URL (indiana.edu)",
				"//value[@type='url' and starts-with (text(), 'http://') and contains (text(), 'indiana.edu')]/text()"
			)

			test_svg_1 ("//svg/g[starts-with (@style, 'stroke:blue')]/line")

			test_svg_2 ("//svg/g[starts-with (@style, 'stroke:black')]/line")

			test_svg_3 ("sum (//svg/g/line/@x1)")
			test_svg_3 ("sum (//svg/g/line/@y1)")

			test_processing_instruction ("vtd-xml/request-matrix-average.xml")
			test_processing_instruction ("vtd-xml/request-matrix-sum.xml")

		end

feature {NONE} -- Tests

	test_spreadsheet
		local
			jobs: EL_SPREAD_SHEET
			data_cell: EL_SPREAD_SHEET_DATA_CELL
		do
			log.enter ("test_spreadsheet")
			create jobs.make ("XML/Jobs-spreadsheet.fods")
			across jobs as table loop
				across table.item as row loop
					across table.item.columns as name loop
						data_cell := row.item.cell (name.item)
						if not data_cell.is_empty then
							if data_cell.text.count > 60 then
								log.put_string_field_to_max_length (name.item, data_cell.text, 200)
							else
								log.put_string_field (name.item, data_cell.text)
							end
							log.put_new_line
						end
					end
					log.put_new_line
				end
			end
			log.exit
		end

	test_bio_1 (xpath: STRING)
			-- Demonstrates nested queries
		local
			log_stack_pos: INTEGER
			par_value_list, label_node_list: EL_XPATH_NODE_CONTEXT_LIST
		do
			-- save call stack count in case of an exception
			log_stack_pos := log.call_stack_count
			log.enter ("test_bio_1")
			label_node_list := bio_info_root_node.context_list (xpath)
			from label_node_list.start until label_node_list.after loop
				log.put_string_field (
					label_node_list.context.name, label_node_list.context.normalized_string_value
				)
				log.put_new_line
				par_value_list := label_node_list.context.context_list (
					"following-sibling::value"
				)
				from par_value_list.start until par_value_list.after loop
					log.put_string_field (
						"@type", par_value_list.context.attributes ["type"]
					)
					log.put_string (" ")
					log.put_string (par_value_list.context.normalized_string_value)
					log.put_new_line
					par_value_list.forth
				end
				log.put_new_line
				label_node_list.forth
			end
			log.exit
		rescue
			log.restore (log_stack_pos)
			if is_developer_exception then
				io.put_string (developer_exception_name)
				io.put_new_line
				io.put_string ("Retry? (y/n) ")
				io.read_line
				if io.last_string.is_equal ("y") then
					retry
				end
			end
		end

	test_bio_2 (xpath: STRING)
			-- list all url values
		do
			log.enter_with_args ("test_bio_2", << xpath >>)
			across bio_info_root_node.context_list (xpath) as label loop
				log.put_line (label.node.normalized_string_value)
			end
			log.exit
		end

	test_bio_3 (xpath: STRING)
			-- list all integer values
		local
			id: STRING
		do
			log.enter_with_args ("test_bio_3", << xpath >>)
			across bio_info_root_node.context_list (xpath) as value loop
				id := value.node.string_at_xpath ("parent::node()/id")
				log.put_integer_field (id, value.node.integer_value)
				log.put_new_line
			end
			log.exit
		end

	test_bio_4 (label, xpath: STRING)
			-- element count
		do
			log.enter_with_args ("test_bio_4", << xpath >>)
			log.put_integer_field (label, bio_info_root_node.context_list (xpath).count)
			log.put_new_line
			log.exit
		end

	test_bio_5 (label, xpath: STRING)
			-- element count
		do
			log.enter_with_args ("test_bio_5", << xpath >>)
			log.put_string_field (label, bio_info_root_node.string_at_xpath (xpath))
			log.put_new_line
			log.exit
		end

	test_svg_1 (xpath: STRING)
			-- distance double coords
		local
			p1, p2: SVG_POINT
		do
			log.enter_with_args ("test_svg_1", << xpath >>)
			across aircraft_power_price_svg_root_node.context_list (xpath) as line loop
				create p1.make (line.node.attributes, 1)
				create p2.make (line.node.attributes, 2)
				log.put_double_field ("line length", p1.distance (p2))
				log.put_new_line
			end
			log.exit
		end

	test_svg_2 (xpath: STRING)
			-- distance integer coords
		local
			line_node_list: EL_XPATH_NODE_CONTEXT_LIST
			p1, p2: SVG_INTEGER_POINT
		do
			log.enter_with_args ("test_svg_2", << xpath >>)
			across aircraft_power_price_svg_root_node.context_list (xpath) as line loop
				create p1.make (line.node.attributes, 1)
				create p2.make (line.node.attributes, 2)
				log.put_double_field ("line length", p1.distance (p2))
				log.put_new_line
			end
			log.exit
		end

	test_svg_3 (xpath: STRING)
			--
		do
			log.enter_with_args ("test_svg_3", << xpath >>)
			log.put_double_field (xpath, aircraft_power_price_svg_root_node.double_at_xpath (xpath))
			log.put_new_line
			log.exit
		end

	test_processing_instruction (file_name: STRING)
			--
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			log.enter_with_args ("test_processing_instruction", << file_name >>)

			create root_node.make_from_file (file_name.as_string_32)

			root_node.find_instruction ("call")
			if root_node.instruction_found then
				log.put_string_field ("call", root_node.found_instruction)
			else
				log.put_string_field ("No such instruction", "call")
			end
			log.put_new_line
			log.exit
		end

feature {NONE} -- Implementation

	bio_file_name: EL_FILE_PATH

	svg_file_name: EL_FILE_PATH

	bio_info_root_node: EL_XPATH_ROOT_NODE_CONTEXT

	aircraft_power_price_svg_root_node: EL_XPATH_ROOT_NODE_CONTEXT

feature {NONE} -- Constants

	Option_name: STRING = "test_vtd_xml"

	Description: STRING = "Test Virtual Token Descriptor xml parser"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{TEST_VTD_XML_APP}, "*"],
				[{EL_XPATH_ROOT_NODE_CONTEXT}, "-*"],
				[{EL_XPATH_NODE_CONTEXT_LIST}, "-*"],
				[{EL_XPATH_NODE_CONTEXT}, "-*"],
				[{EL_VTD_EXCEPTIONS}, "*"],
				[{EL_SPREAD_SHEET}, "*"]
			>>
		end

end

