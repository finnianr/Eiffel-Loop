note
	description: "Boolean option that can be enabled or disabled and can optionally notify an action procedure"
	notes: "[
		This class is suggested as a better alternative to following frequently seen code pattern

			feature -- Status query
			
				is_option_enabled: BOOLEAN

			feature -- Status change

				disable_option
					do
						is_option_enabled := True
					end

				enable_option
					do
						is_option_enabled := False
					end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-15 7:37:33 GMT (Saturday 15th June 2019)"
	revision: "4"

class
	EL_BOOLEAN_OPTION

inherit
	BOOLEAN_REF
		rename
			item as is_enabled,
			set_item as set_state
		export
			{NONE} all
			{ANY} is_enabled, set_state
		end

	EL_MAKEABLE_FROM_STRING_8
		rename
			make as make_from_string,
			make_default as make_enabled
		undefine
			out
		end

create
	default_create, make_enabled, make, set_state

convert
	set_state ({BOOLEAN})

feature {NONE} -- Initialization

	make (enabled: BOOLEAN; a_action: PROCEDURE [BOOLEAN])
		do
			set_state (enabled); action := a_action
		end

	make_enabled
		do
			enable
		end

	make_from_string (a_string: STRING)
		do
			set_state (a_string.to_boolean)
		end

feature -- Status query

	is_disabled: BOOLEAN
		do
			Result := not is_enabled
		end

feature -- Status change

	disable
		do
			set_state (False)
			notify
		end

	enable
		do
			set_state (True)
			notify
		end

	invert
		-- invert state
		do
			if is_enabled then
				disable
			else
				enable
			end
		end

feature -- Element change

	set_action (a_action: PROCEDURE [BOOLEAN])
		do
			action := a_action
		end

feature -- Access

	to_string: STRING
		do
			Result := out
		end

feature {NONE} -- Implementation

	notify
		do
			if attached action as on_change then
				on_change (is_enabled)
			end
		end

feature {NONE} -- Internal attributes

	action: detachable PROCEDURE [BOOLEAN]

end
