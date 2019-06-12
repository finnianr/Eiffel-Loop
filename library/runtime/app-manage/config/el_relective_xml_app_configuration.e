note
	description: "Relective xml app configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-12 14:14:59 GMT (Wednesday 12th June 2019)"
	revision: "1"

deferred class
	EL_RELECTIVE_XML_APP_CONFIGURATION

inherit
	EL_APP_CONFIGURATION
		undefine
			is_equal
		end

	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML

feature {NONE} -- Constants

	Base_name: ZSTRING
		once
			Result := "config.xml"
		end
end
