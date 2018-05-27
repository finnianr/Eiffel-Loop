note
	description: "Extension edition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_EXTENSION_EDITION [STORABLE_TYPE -> EL_STORABLE_XML_ELEMENT]

inherit
	EL_XML_ELEMENT_EDITION [STORABLE_TYPE]

create
	make, default_create

feature {NONE} -- Initialization

	make (a_element: STORABLE_TYPE)
			--
		do
			make_default
			element := a_element
			has_element := True
		end

feature {NONE} -- Implementation

	apply (target: LIST [STORABLE_TYPE])
			-- Apply extend transaction to target list
		do
			target.extend (element)
		end

feature {NONE} -- Constants

	Template: STRING =
		--
	"[
		<edition-extend>
			#evaluate ($element.template_name, $element)
		</edition-extend>
	]"

end
