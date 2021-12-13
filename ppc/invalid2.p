var i: integer;

begin
    i:= 8;
    case valof resultis i end of
        2:
            i := 1;
      | 4:
            i := 2;
    else
        i := i + 1;
    end;
    print_num(i); newline()
end.