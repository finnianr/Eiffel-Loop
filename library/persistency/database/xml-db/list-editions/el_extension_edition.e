note
	description: "Extension edition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

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