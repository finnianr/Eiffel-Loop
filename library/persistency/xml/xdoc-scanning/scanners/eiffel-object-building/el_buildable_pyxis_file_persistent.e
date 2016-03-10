note
	description: "Summary description for {EL_BUILDABLE_PYXIS_FILE_PERSISTENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
