note
	description: "Application configuration relectively storable as XML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-13 9:14:04 GMT (Thursday 13th June 2019)"
	revision: "2"

deferred class
	EL_RELECTIVE_XML_APP_CONFIGURATION

inherit
	EL_APPLICATION_CONFIGURATION
		undefine
			is_equal
		end

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
