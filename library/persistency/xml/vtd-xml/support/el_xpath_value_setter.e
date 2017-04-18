note
	description: "Summary description for {EL_XPATH_VALUE_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-18 11:30:42 GMT (Tuesday 18th April 2017)"
	revision: "2"

deferred class
	EL_XPATH_VALUE_SETTER [G]

feature -- Basic operations

	set_from_node (node: EL_XPATH_NODE_CONTEXT; a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [ANY, TUPLE [G]])
		local
			parts: like xpath_parts
		do
			parts := xpath_parts (a_xpath)
			if parts.xpath.is_empty then
				set_value (attribute_value (node.attributes, parts.attribute_name))
			else
				node.find_node (parts.xpath)
				if node.node_found then
					if parts.attribute_name.is_empty then
						set_value (node_value (node.found_node))
					else
						set_value (attribute_value (node.found_node.attributes, parts.attribute_name))
					end
				end
			end
		end

feature {NONE} -- Implementation

	xpath_parts (a_xpath: READABLE_STRING_GENERAL): like Once_xpath_parts
		do
			Result := Once_xpath_parts
			Result.set_from_xpath (a_xpath)
		end

	attribute_value (table: EL_ELEMENT_ATTRIBUTE_TABLE; name: READABLE_STRING_GENERAL): G
		deferred
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): G
		deferred
		end

feature {NONE} -- Constants

	Once_xpath_parts: EL_XPATH_PARTS
		once
			create Result
		end

end
