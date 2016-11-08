note
	description: "[
		thread to apply routines distributed by class [../communication/producer-consumer/el_work_distributer.html EL_WORK_DISTRIBUTER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-11-07 10:07:13 GMT (Monday 7th November 2016)"
	revision: "1"

class
	EL_WORK_DISTRIBUTION_THREAD [BASE_TYPE]

inherit
	EL_CONTINUOUS_ACTION_THREAD

create
	make

feature {NONE} -- Initialization

	make (a_distributer: like distributer)
		do
			make_default
			distributer := a_distributer
		end

feature -- Basic operations

	loop_action
			--
		do
			distributer.wait_to_apply
		end

feature {NONE} -- Internal attributes

	distributer: EL_WORK_DISTRIBUTER [BASE_TYPE]
end
