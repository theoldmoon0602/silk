%{
  open Syntax
%}

%token EQUAL
%token COMMA COLON
%token PLUS MINUS ASTERISK SLASH
%token LANGLE RANGLE LANGLE_EQ RANGLE_EQ EQEQ NOTEQ
%token LPAREN RPAREN LBRACE RBRACE
%token EOF
%token DEF
%token IF ELSE
%token TRUE FALSE
%token <int> NUM
%token <string> ID

%start toplevel
%type <Syntax.exp> toplevel

%%

toplevel:
  |Expr* EOF { MultiExpr($1) }

Expr:
  |AssignExpr { $1 }

AssignExpr:
  |DEF id=ID EQUAL exp=Arithmetic { Assign(id, None, exp) }
  |DEF id=ID COLON t=Typ EQUAL exp=Arithmetic { Assign(id, Some(t), exp) }
  |Arithmetic { $1 }

Arithmetic:
  |Arithmetic PLUS Term { Call ("+", [$1; $3]) }
  |Arithmetic MINUS Term { Call ("-", [$1; $3]) }
  |Term { $1 }

Term:
  |Term ASTERISK Factor { Call ("*", [$1; $3]) }
  |Term SLASH Factor { Call ("/", [$1; $3]) }
  |Compare { $1 }

Compare:
  |Compare EQEQ Factor { Call ("==", [$1; $3]) }
  |Compare NOTEQ Factor { Call ("!=", [$1; $3]) }
  |Compare LANGLE Factor { Call ("<", [$1; $3]) }
  |Compare RANGLE Factor { Call (">", [$1; $3]) }
  |Compare LANGLE_EQ Factor { Call ("<=", [$1; $3]) }
  |Compare RANGLE_EQ Factor { Call (">=", [$1; $3]) }
  |Factor { $1 }

Factor:
  |MINUS Factor { Call("__neg", [$2]) }
  |Num { $1 }
  |IfExpr { $1 }
  |fname = ID LPAREN args = separated_list(COMMA, Expr) RPAREN { Call (fname, args) }
  |LBRACE list(Expr) RBRACE  { MultiExpr ( $2 ) }
  |LPAREN Expr RPAREN  { $2 }
  |DefunExpr { $1 }

DefunExpr:
  |DEF name = ID LPAREN args = separated_list(COMMA, Arg)
   RPAREN EQUAL body = Expr { Defun(name, args, None, body) }
  |DEF name = ID LPAREN args = separated_list(COMMA, Arg)
   RPAREN COLON rett=Typ EQUAL body = Expr { Defun(name, args, Some(rett), body) }

Arg:
  |name=ID { (name, None) }
  |name=ID COLON t=Typ { (name, Some(t)) }

IfExpr:
  |IF cond = Expr t = Expr ELSE e = Expr { If(cond, t, e) }

Num:
  |ID { Var $1 }
  |NUM { Int $1 }
  |TRUE { Bool(true) }
  |FALSE { Bool(false) }

Typ:
  |ID { $1 }

