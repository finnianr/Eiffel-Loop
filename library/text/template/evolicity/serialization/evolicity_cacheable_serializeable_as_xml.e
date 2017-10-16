note
	description: "Summary description for {EVOLICITY_CACHEABLE_SERIALIZEABLE_AS_XML}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EVOLICITY_CACHEABLE_SERIALIZEABLE_AS_XML

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			to_xml as new_xml,
			to_utf_8_xml as new_utf_8_xml
		export
			{NONE} new_xml, new_utf_8_xml
		redefine
			make_default
		end

	EVOLICITY_CACHEABLE
		rename
			as_text as to_xml,
			as_utf_8_text as to_utf_8_xml,
			new_text as new_xml,
			new_utf_8_text as new_utf_8_xml
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EVOLICITY_SERIALIZEABLE_AS_XML}
			Precursor {EVOLICITY_CACHEABLE}
		end
end