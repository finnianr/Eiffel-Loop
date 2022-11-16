note
	description: "Application configuration relectively storable as XML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	EL_RELECTIVE_XML_APP_CONFIGURATION

inherit
	EL_APPLICATION_CONFIGURATION

	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
		export
			{NONE} all
		end

feature {NONE} -- Constants

	Base_name: ZSTRING
		once
			Result := "config.xml"
		end
end