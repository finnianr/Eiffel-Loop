note
	description: "Storable rsa key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-07 12:18:57 GMT (Thursday 7th September 2023)"
	revision: "11"

deferred class
	EL_STORABLE_RSA_KEY

inherit
	EL_MODULE_RSA

feature {NONE} -- Implementation

	rsa_value (xdoc: EL_XML_DOC_CONTEXT; id: STRING): INTEGER_X
			--
		do
			if not id.is_empty then
				Value_xpath.set_variable ("id", id)
			end
			Result := Rsa.integer_x_from_base_64 (xdoc.query (Value_xpath.substituted))
		end

	value_xpath: EL_STRING_8_TEMPLATE
			--
		deferred
		end

end