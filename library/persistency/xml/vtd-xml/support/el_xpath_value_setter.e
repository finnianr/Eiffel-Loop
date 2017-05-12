note
	description: "[
		These map the value of a xpath specified node to an Eiffel field setting agent. The agent
		is called only if the node is found. The xpath can specify either an XML element or attribute.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-20 12:12:23 GMT (Thursday 20th April 2017)"
	revision: "3"

deferred class
	EL_XPATH_VALUE_SETTER [G]

feature -- Basic operations

	set_from_node (node: EL_XPATH_NODE_CONTEXT; a_xpath: READABLE_STRING_GENERAL; set_value: PROCEDURE [ANY, TUPLE [G]])
		local
			parts: like xpath_parts
		do
			parts := xpath_parts (a_xpath)
			if parts.xpath.is_empty then
				try_set_attribute (node, parts, set_value)
			else
				node.find_node (parts.xpath)
				if node.node_found then
					if parts.attribute_name.is_empty then
						set_value (node_value (node.found_node))
					else
						try_set_attribute (node.found_node, parts, set_value)
					end
				end
			end
		end

feature {NONE} -- Implementation

	try_set_attribute (node: EL_XPATH_NODE_CONTEXT; parts: like xpath_parts; set_value: PROCEDURE [ANY, TUPLE [G]])
		do
			if node.attributes.has (parts.attribute_name) then
				set_value (attribute_value (node.attributes, parts.attribute_name))
			end
		end

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
