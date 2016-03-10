note
	description: "Summary description for {EL_BUILDABLE_PYXIS_FILE_PERSISTENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-06 10:47:45 GMT (Tuesday 6th January 2015)"
	revision: "4"

deferred class
	EL_BUILDABLE_PYXIS_FILE_PERSISTENT

inherit
	EL_BUILDABLE_XML_FILE_PERSISTENT
		redefine
			Builder
		end

feature {NONE} -- Constants

	Builder: EL_XML_TO_EIFFEL_OBJECT_BUILDER
			--
		once
			create Result.make_pyxis_source
		end
end
