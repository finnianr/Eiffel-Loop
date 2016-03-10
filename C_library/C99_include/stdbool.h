#ifndef _STDBOOL_H_
#define	_STDBOOL_H_

typedef int _Bool;

#ifndef __cplusplus
#define	bool	_Bool

#define	true	1
#define	false	0
#else
#define	bool	bool

#define	true	true
#define	false	false
#endif /* __cplusplus */

#define	__bool_true_false_are_defined	1

#endif /* _STDBOOL_H_ */