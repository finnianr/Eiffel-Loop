note
	description: "Application configuration relectively storable as XML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:47:27 GMT (Monday 1st July 2019)"
	revision: "3"

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
