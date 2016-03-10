This class makes available all of the numeric functions provided in the standard C run-time library from <math.h>.

It also implements "safe" versions of some trigonometric functions. With numerical computation noise, is is not uncommon, for example, to attempt to take the arc sine of a number just greater than one. The "safe" arc sine will truncate this argument to one and not trigger a domain error. However, blindly using the safe trig functions without understanding the numeric precision issues with your software will inevitably lead to false results. Use them with caution.

Greg Lee
October 2005
