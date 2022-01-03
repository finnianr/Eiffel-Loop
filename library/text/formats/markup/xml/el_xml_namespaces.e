note
	description: "Xml namespaces"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "9"

class
	EL_XML_NAMESPACES

inherit
	ANY EL_MODULE_FILE_SYSTEM

create
	make, make_from_other, make_from_file

feature {NONE} -- Initaliazation

	make_from_file (file_name: FILE_PATH)
			--
		do
			make (File_system.plain_text (file_name))
		end

	make_from_other (other: EL_XML_NAMESPACES)
		do
			namespace_urls := other.namespace_urls
		end

	make (xml: STRING)
		local
			xmlns_intervals: EL_OCCURRENCE_INTERVALS [STRING]
			pos_double_quote: INTEGER; declaration, value: STRING
		do
			create xmlns_intervals.make_by_string (xml, Xml_namespace_marker)
			create namespace_urls.make_equal (xmlns_intervals.count)
			namespace_urls.compare_objects
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
						namespace_urls.put (value, namespace_prefix_and_url.first)
					end
				end
				xmlns_intervals.forth
			end
		end

feature -- Access

	namespace_urls: HASH_TABLE [STRING, STRING]

feature {NONE} -- Constants

	Double_quote: CHARACTER = '"'

	Xml_namespace_marker: STRING = "xmlns:"

end