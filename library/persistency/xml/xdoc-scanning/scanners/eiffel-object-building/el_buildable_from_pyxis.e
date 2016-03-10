note
	description: "Summary description for {EL_BUILDABLE_FROM_PYXIS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-06 10:47:46 GMT (Tuesday 6th January 2015)"
	revision: "4"

deferred class
	EL_BUILDABLE_FROM_PYXIS

inherit
	EL_BUILDABLE_FROM_XML
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
