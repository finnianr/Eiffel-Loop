note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_XPATH_TO_AGENT_MAP

create
	make, make_from_tuple

feature {NONE} -- Initialization

	make (applied_to_open_element: BOOLEAN; a_xpath: STRING; a_action: like action)
			--
		do
			is_applied_to_open_element := applied_to_open_element
			xpath := a_xpath
			action := a_action
		end

	make_from_tuple (tuple: TUPLE [STRING, BOOLEAN, like action])
			--
		do
			if attached {STRING} tuple.reference_item (1) as a_xpath
				and then attached {PROCEDURE [ANY, TUPLE]} tuple.reference_item (3) as a_action
			then
				make (tuple.boolean_item (2), a_xpath, a_action)
			end
		end

feature -- Access

	action: PROCEDURE [ANY, TUPLE]

	xpath: STRING

	is_applied_to_open_element: BOOLEAN

end -- class EL_XPATH_TO_AGENT_MAP

