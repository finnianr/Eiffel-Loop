note
	description: "Summary description for {EL_BUILDABLE_FROM_PYXIS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_BUILDABLE_FROM_PYXIS

inherit
	EL_BUILDABLE_FROM_XML
		rename
			make_default as make
		redefine
			Builder
		end

feature {NONE} -- Globals

	Builder: EL_XML_TO_EIFFEL_OBJECT_BUILDER
			--
		once
			create Result.make_pyxis_source
		end

end
