note
	description: "Default serializeable XML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_DEFAULT_SERIALIZEABLE_XML

inherit
	EL_SERIALIZEABLE_AS_XML

feature -- Conversion

	to_xml: STRING
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