note
	description: "Create edited version of class ${EV_ENVIRONMENT_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 12:50:21 GMT (Friday 18th December 2015)"
	revision: "1"

class
	EV_ENVIRONMENT_I_CLASS

inherit
	OVERRIDE_FEATURE_EDITOR

create
	make

feature {NONE} -- Implementation

	change_type_of_implementation_object (class_feature: CLASS_FEATURE)
			-- Change `create {EV_APPLICATION_IMP}' to `create {EL_APPLICATION_IMP}'
		local
			lines: EDITABLE_SOURCE_LINES
		do
			lines := class_feature.lines
			from lines.start until lines.after loop
				if lines.item.has_substring ("{EV_APPLICATION_IMP}") then
					lines.item.replace_substring_all ("{EV_", "{EL_")
					lines.append_comment ("changed implementation type")
				end
				lines.forth
			end
		end

	dir_path: DIR_PATH
		-- original ISE location
		do
			Result := "vision2/implementation/implementation_interface/kernel"
		end

	new_feature_edit_actions: like feature_edit_actions
		do
			create Result
			Result ["new_application_i"] := agent change_type_of_implementation_object
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 2556752336

end
