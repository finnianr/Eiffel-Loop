note
	description: "[
		thread to apply routines distributed by class
		[../communication/producer-consumer/el_work_distributer.html EL_WORK_DISTRIBUTER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-12 9:02:31 GMT (Friday 12th May 2017)"
	revision: "3"

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
