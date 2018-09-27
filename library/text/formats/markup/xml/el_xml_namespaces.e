note
	description: "Xml namespaces"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_XML_NAMESPACES

inherit
	EL_MODULE_FILE_SYSTEM

create
	make, make_from_other, make_from_file

feature {NONE} -- Initaliazation

	make_from_file (file_name: EL_FILE_PATH)
			--
		do
			make (File_system.plain_text (file_name))
		end

	make_from_other (other: EL_XML_NAMESPACES)
		do
			namespace_urls := other.namespace_urls
		end

	make (xml: STRING)
			--
		local
			xmlns_intervals: EL_SEQUENTIAL_INTERVALS; namespace_prefix_and_url: LIST [ZSTRING]
			pos_double_quote: INTEGER; declaration, l_xml: ZSTRING
		do
			l_xml := xml
			create namespace_urls.make_equal (11)
			namespace_urls.compare_objects
			xmlns_intervals := l_xml.substring_intervals (Xml_namespace_marker)
			from xmlns_intervals.start until xmlns_intervals.after loop
				if xml.item (xmlns_intervals.item_lower - 1).is_space then
					pos_double_quote := xml.index_of (Double_quote, xmlns_intervals.item_upper + 1)
					pos_double_quote := xml.index_of (Double_quote, pos_double_quote + 1)

					declaration := xml.substring (xmlns_intervals.item_upper + 1, pos_double_quote)
					namespace_prefix_and_url := declaration.split ('=')
					namespace_prefix_and_url.last.remove_quotes
					namespace_urls.put (namespace_prefix_and_url.last, namespace_prefix_and_url.first)
				end
				xmlns_intervals.forth
			end
		end

feature -- Access

	namespace_urls: EL_ZSTRING_HASH_TABLE [ZSTRING]

feature {NONE} -- Constants

	Double_quote: CHARACTER = '"'

	Xml_namespace_marker: ZSTRING
		once
			Result := "xmlns:"
		end

end