note
	description: "Summary description for {EL_DEFAULT_SERIALIZEABLE_XML}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_DEFAULT_SERIALIZEABLE_XML

inherit
	EL_SERIALIZEABLE_AS_XML

feature -- Conversion

	to_xml: ASTRING
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
