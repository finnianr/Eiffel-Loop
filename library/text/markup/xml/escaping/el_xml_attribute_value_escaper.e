note
	description: "Summary description for {EL_XML_ATTRIBUTE_VALUE_BASIC_CHARACTER_ESCAPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_XML_ATTRIBUTE_VALUE_ESCAPER

inherit
	EL_XML_CHARACTER_ESCAPER
		redefine
			make
		end

create
	make, make_128_plus

feature {NONE} -- Initialization

	make
		do
			Precursor
			predefined_entities [{CHARACTER_32}'"'] := named_entity ("quot")
		end

end
