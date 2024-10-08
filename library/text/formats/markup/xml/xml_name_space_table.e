note
	description: "XML name space table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 16:08:02 GMT (Sunday 22nd September 2024)"
	revision: "15"

class
	XML_NAME_SPACE_TABLE

inherit
	EL_HASH_TABLE [STRING, STRING]
		rename
			make as make_sized
		export
			{NONE} all
			{ANY} has_key, found_item, item, count
		end

	EL_MODULE_FILE

create
	make, make_from_other, make_from_file

feature {NONE} -- Initaliazation

	make_from_file (file_name: FILE_PATH)
			--
		do
			make (File.plain_text (file_name))
		end

	make_from_other (other: XML_NAME_SPACE_TABLE)
		do
			make_equal (other.count)
			merge (other)
		end

	make (xml: STRING)
		local
			xmlns_intervals: EL_OCCURRENCE_INTERVALS
			pos_double_quote: INTEGER; declaration, value: STRING
		do
			create xmlns_intervals.make_by_string (xml, Xml_namespace_marker)
			make_equal (xmlns_intervals.count)
			compare_objects
			from xmlns_intervals.start until xmlns_intervals.after loop
				if xml.item (xmlns_intervals.item_lower - 1).is_space then
					pos_double_quote := xml.index_of (Double_quote, xmlns_intervals.item_upper + 1)
					pos_double_quote := xml.index_of (Double_quote, pos_double_quote + 1)
					declaration := xml.substring (xmlns_intervals.item_upper + 1, pos_double_quote)
					if attached declaration.split ('=') as namespace_prefix_and_url
						and then namespace_prefix_and_url.count = 2
					then
						value := namespace_prefix_and_url.last
						if value.count >= 2 then
							value.remove_head (1); value.remove_tail (1)
						end
						put (value, namespace_prefix_and_url.first)
					end
				end
				xmlns_intervals.forth
			end
		end

feature {NONE} -- Constants

	Double_quote: CHARACTER = '"'

	Xml_namespace_marker: STRING = "xmlns:"

	Xmlns: STRING = "xmlns"

end