note
	description: "Xpath to agent map"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-23 16:14:16 GMT (Sunday 23rd July 2023)"
	revision: "8"

class
	EL_XPATH_TO_AGENT_MAP

create
	make, make_from_tuple, make_from_node_tuple

convert
	make_from_tuple ({TUPLE [BOOLEAN, STRING, PROCEDURE]}),
	make_from_node_tuple ({TUPLE [BOOLEAN, STRING, PROCEDURE [EL_DOCUMENT_NODE_STRING]]})

feature {NONE} -- Initialization

	make (applied_to_open_element: BOOLEAN; a_xpath: STRING; a_action: PROCEDURE)
			--
		require
			valid_action: a_action.open_count = 0 or else accepts_node_argument (a_action)
		do
			is_applied_to_open_element := applied_to_open_element
			xpath := a_xpath; action := a_action
			requires_node := accepts_node_argument (a_action)
		end

	make_from_tuple (args: TUPLE [on_open: BOOLEAN; a_xpath: STRING; a_action: PROCEDURE])
			--
		do
			make (args.on_open, args.a_xpath, args.a_action)
		end

	make_from_node_tuple (
		args: TUPLE [on_open: BOOLEAN; a_xpath: STRING; a_action: PROCEDURE [EL_DOCUMENT_NODE_STRING]]
	)
			--
		do
			make (args.on_open, args.a_xpath, args.a_action)
		end

feature -- Access

	action: PROCEDURE

	apply (node: like Document_node)
		do
			if requires_node then
				action (node)
			else
				action.apply
			end
		end

	is_applied_to_open_element: BOOLEAN

	requires_node: BOOLEAN
		-- `True' if `action' requires a `last_node: EL_DOCUMENT_NODE_STRING' argument

	xpath: STRING

feature -- Contract Support

	accepts_node_argument (a_action: PROCEDURE): BOOLEAN
		do
			if a_action.open_count = 1 and then a_action.valid_operands ([Document_node]) then
				Result := True
			end
		end

feature {NONE} -- Constants

	Document_node: EL_DOCUMENT_NODE_STRING
		once
			create Result.make_default
		end

end