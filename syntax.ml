type exp =
  |Int of int
  |Add of exp * exp
  |Mul of exp * exp
  |Sub of exp * exp
  |Div of exp * exp
  |Neg of exp
  |Call of string * exp
  |Assign of string * exp
  |Var of string

type stmt =
  |Exp of exp
  |Defun of string * stmt list
