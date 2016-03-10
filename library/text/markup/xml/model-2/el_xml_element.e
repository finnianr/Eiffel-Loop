note
	description: "Summary description for {EL_XML_ELEMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_XML_ELEMENT

inherit
	EL_MODULE_XML

	EL_STRING_CONSTANTS

feature -- Access

	name: ASTRING
		deferred
		end

feature -- Basic operations

	write (medium: EL_OUTPUT_MEDIUM)
		deferred
		end

end
