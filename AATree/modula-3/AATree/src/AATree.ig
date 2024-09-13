GENERIC INTERFACE AATree(Elem);

CONST
  Brand = "AATree(" & Elem.Brand & ")";
  
TYPE
  T <: REFANY;
  ToTextProc = PROCEDURE(READONLY Key:Elem.T):TEXT;

PROCEDURE Insert(Tree:T;READONLY Key:Elem.T):T;
PROCEDURE Print(Tree:T;Space:TEXT;READONLY Proc:ToTextProc);
    
END AATree.

