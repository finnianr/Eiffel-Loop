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
	date: "2022-11-05 11:15:44 GMT (Saturday 5th November 2022)"
	revision: "7"

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

	EL_MAKEABLE_FROM_STRING [STRING_8]
		rename
			make as make_from_string,
			make_default as default_create
		undefine
			out
		end

create
	default_create, make_enabled, make, make_with_action, make_from_string

convert
	make ({BOOLEAN})

feature {NONE} -- Initialization

	make (enabled: BOOLEAN)
		do
			default_create
			set_state (enabled)
		end

	make_enabled
		do
			make (True)
		end

	make_from_string (a_string: STRING)
		do
			make (a_string.to_boolean)
		end

	make_with_action (enabled: BOOLEAN; a_action: PROCEDURE [BOOLEAN])
		do
			make (enabled)
			action := a_action
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

feature -- Access

	to_string: STRING
		do
			Result := out
		end

feature -- Basic operations

	notify
		do
			if attached action as l_action then
				l_action (is_enabled)
			end
		end

feature {NONE} -- Internal attributes

	action: detachable PROCEDURE [BOOLEAN]
end