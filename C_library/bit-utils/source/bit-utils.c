/*
   bit-utils.c: Eiffel bridge

   Copyright (C) 2017

	License: MIT https://en.wikipedia.org/wiki/MIT_License


   Author: Finnian Reilly 
	Contact: "finnian at eiffel hyphen loop dot com"
*/


int builtin_bit_count (unsigned int n){
	return __builtin_popcount (n);
}
	
