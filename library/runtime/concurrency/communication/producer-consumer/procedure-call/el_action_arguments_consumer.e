note
	description: "Consumer of arguments to an action or sequence of actions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	EL_ACTION_ARGUMENTS_CONSUMER  [OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_CONSUMER [OPEN_ARGS]
		rename
			consume_product as call_actions,
			product as arguments
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create sequence
		end

feature -- Element change

	extend (a_action: like action)
			--
		do
			if sequence.count > 0 then
				sequence.extend (action)

			elseif attached action then
				-- make both part of sequence
				sequence.extend (action)
				action := Void
				sequence.extend (a_action)

			else
				action := a_action
			end
		ensure
			valid_state: sequence.count > 0 implies not attached action
		end

	set_action (a_action: like action)
		require
			only_one: not has_multiple
		do
			action := a_action
		end

	wipe_out
		do
			sequence.wipe_out
			action := Void
		end

feature -- Status query

	has_multiple: BOOLEAN
		do
			Result := sequence.count > 0
		end

feature {NONE} -- Implementation

	call_actions
		-- consume argument for either `sequence' or `action' but not both
		do
			if attached action as l_action then
				l_action.call (arguments)

			elseif sequence.count > 0 then
				sequence.call (arguments)
			end
		end

feature {NONE} -- Internal attributes

	action: detachable PROCEDURE [OPEN_ARGS]

	sequence: ACTION_SEQUENCE [OPEN_ARGS]

end