GENERIC MODULE AATree(Elem);

IMPORT SIO;

REVEAL T = BRANDED Brand REF RECORD
  Key:Elem.T;
  Left,Right:T := NIL;
  Level:INTEGER := 1;
END;

PROCEDURE Skew(Tree:T):T =
  VAR L:T := NIL;
  BEGIN
    IF Tree = NIL OR Tree.Left = NIL THEN RETURN Tree END;
    (* Red node to the left? Do a right rotation. *)
    IF Tree.Left.Level = Tree.Level THEN
      L := Tree.Left;
      Tree.Left := L.Right;
      L.Right := Tree;
      RETURN L
    END;
    RETURN Tree
  END Skew;

PROCEDURE Split(Tree:T):T =
  VAR L:T := NIL;
  BEGIN
    IF Tree = NIL OR Tree.Right = NIL OR Tree.Right.Right = NIL THEN
      RETURN Tree
    END;
    (* Right-right red chain? Do a left rotation. *)
    IF Tree.Right.Right.Level = Tree.Level THEN
      L := Tree.Right;
      Tree.Right := L.Left;
      L.Left := Tree;
      INC(L.Level);
      RETURN L
    END;
    RETURN Tree
  END Split;

PROCEDURE Insert(Tree:T;READONLY Key:Elem.T):T =
  BEGIN
    IF Tree = NIL THEN
      RETURN NEW(T,Key := Key)
    END;
    IF Elem.Compare(Key,Tree.Key) < 0 THEN
      Tree.Left := Insert(Tree.Left,Key)
    ELSE
      Tree.Right := Insert(Tree.Right,Key)
    END;
    RETURN Split(Skew(Tree))
  END Insert;

PROCEDURE Print(Tree:T;Space:TEXT;READONLY Proc:ToTextProc) =
  BEGIN
    IF Tree.Left # NIL THEN
      Print(Tree.Left,Space & "  ",Proc)
    END;
    SIO.PutText(Space & Proc(Tree.Key) & "\n");
    IF Tree.Right # NIL THEN
      Print(Tree.Right,Space & "  ",Proc)
    END;
  END Print;
  
BEGIN
  
END AATree.

