MODULE Main;

FROM StableError IMPORT Halt;
IMPORT Fmt,Params,OSError,FloatMode,
       Lex,Thread,Rd,FileRd,Scan,TextConv;
IMPORT IntAATree;

PROCEDURE Proc(READONLY Key:INTEGER):TEXT =
  BEGIN
    RETURN Fmt.Int(Key)
  END Proc;

VAR
  Tree:IntAATree.T;
  Reader:Rd.T;
  A:REF ARRAY OF TEXT;
  Numbers:REF ARRAY OF INTEGER;
  Line:TEXT := "";
  Len:CARDINAL := 0;
  
BEGIN
  IF Params.Count # 2 THEN
    Halt("No input file provided!\n")
  END;
  TRY
    TRY
      (* Reading the file: *)
      Reader := FileRd.Open(Params.Get(1));      
      (* Reading the file integers into the sequence: *)
      WHILE NOT Rd.EOF(Reader) DO
        Line := Rd.GetLine(Reader);
        Len := TextConv.ExplodedSize(Line,
                                     SET OF CHAR{' ','\t','\n','\r','\f'});
        A := NEW(REF ARRAY OF TEXT,Len);
        Numbers := NEW(REF ARRAY OF INTEGER,Len);
        TextConv.Explode(Line,A^,SET OF CHAR{' ','\t','\n','\r','\f'});
        FOR I := FIRST(A^) TO LAST(A^) DO
          Numbers[I] := Scan.Int(A[I])
        END
      END;
    EXCEPT
      OSError.E => Halt("File doesn't exist!\n")
    | Rd.Failure => Halt("Failed reading file!\n")
    | Thread.Alerted => Halt("Thread.Alerted exception caught!\n")
    | Rd.EndOfFile => Halt("Reached EOF!\n")
    | FloatMode.Trap => Halt("FloatMode.Trap caught!\n")
    | Lex.Error => Halt("Malformed integer!\n")
    ELSE
      Halt("Some other exception occured!\n")
    END
  FINALLY
    Rd.Close(Reader);
  END;

  FOR I := FIRST(Numbers^) TO LAST(Numbers^) DO
    Tree := IntAATree.Insert(Tree,Numbers[I])
  END;
  
  IntAATree.Print(Tree,"",Proc)
END Main.

