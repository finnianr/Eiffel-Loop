note
	description: "Summary description for {EL_DEFAULT_SERIALIZEABLE_XML}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_DEFAULT_SERIALIZEABLE_XML

inherit
	EL_SERIALIZEABLE_AS_XML

feature -- Conversion

	to_xml: ZSTRING
			--
		do
			Result := Default_xml
		end

	to_utf_8_xml: STRING
			--
		do
			Result := Default_xml
		end

feature {NONE} -- Constants

	Default_xml: STRING =
		--
	"[
		<?xml version="1.0" encoding="UTF-8"?>
		<default/>
	]"

end