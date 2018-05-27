note
	description: "Replacement edition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_REPLACEMENT_EDITION [STORABLE_TYPE -> EL_STORABLE_XML_ELEMENT]

inherit
	EL_XML_ELEMENT_EDITION [STORABLE_TYPE]

create
	make, default_create

feature {NONE} -- Initialization

	make (a_element: STORABLE_TYPE; a_index: INTEGER)
			--
		do
			make_default
			element := a_element
			index := a_index
			has_element := True
		end

feature {NONE} -- Implementation

	apply (target: LIST [STORABLE_TYPE])
			-- Apply replacement transaction to target list
		do
			target.go_i_th (index)
			target.replace (element)
		end

feature {NONE} -- Constants

	Template: STRING =
		--
	"[
		<edition-replace index="$index">
			#evaluate ($element.template_name, $element)
		</edition-replace>
	]"

end
