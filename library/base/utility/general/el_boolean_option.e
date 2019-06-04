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
	date: "2019-06-01 9:48:02 GMT (Saturday 1st June 2019)"
	revision: "2"

class
	EL_BOOLEAN_OPTION

inherit
	BOOLEAN_REF
		rename
			item as is_enabled
		export
			{NONE} all
			{ANY} is_enabled
		end

create
	default_create, make_enabled, make, set_item

convert
	set_item ({BOOLEAN})

feature {NONE} -- Initialization

	make (enabled: BOOLEAN; a_action: PROCEDURE [BOOLEAN])
		do
			set_item (enabled); action := a_action
		end

	make_enabled
		do
			enable
		end

feature -- Status query

	is_disabled: BOOLEAN
		do
			Result := not is_enabled
		end

feature -- Status change

	disable
		do
			set_item (False)
			notify
		end

	enable
		do
			set_item (True)
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
