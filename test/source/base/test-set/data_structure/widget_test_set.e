note
	description: "[
		An experiment to show how it might be possible to achieve Java-like stream functionality in Eiffel
		by reproducing the following example:
		
			int sum = widgets.stream().filter(w -> w.getColor() == RED)
												.mapToInt(w -> w.getWeight())
												.sum();
	                      
			See: [https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html java/util/stream/Stream]
	       
			This example has now become a test set for the [$source EL_CHAIN] class.
			See [$source CONTAINER_STRUCTURE_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-29 8:15:14 GMT (Saturday 29th April 2023)"
	revision: "4"

class
	WIDGET_TEST_SET

inherit
	CONTAINER_STRUCTURE_TEST_SET

end