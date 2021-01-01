note
	description: "XML element attribute node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-01 14:45:17 GMT (Friday 1st January 2021)"
	revision: "9"

class
	EL_ELEMENT_ATTRIBUTE_NODE

inherit
	EL_DOCUMENT_NODE
		export
			{NONE} set_type
		redefine
			make, xpath_name
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create cached_xpath_name.make_filled ('@', 1)
			type := Node_type_attribute
		end

feature -- Access

	xpath_name: STRING_32
		--
		do
			if cached_xpath_name.count = 1 then
				cached_xpath_name.append (name)

			elseif not cached_xpath_name.same_characters (name, 1, name.count, 2) then
				cached_xpath_name.replace_substring (name, 2, cached_xpath_name.count)
			end
			Result := cached_xpath_name
		ensure then
			valid: Result.count = name.count  + 1 and then Result.ends_with (name)
		end

feature {NONE} -- Implementation

	cached_xpath_name: like xpath_name

end