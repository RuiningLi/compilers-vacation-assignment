var i: integer;

begin
    i:= 8;
    case i of
        valof resultis 2 end:
            i := 1;
      | valof resultis 4 end:
            i := 2;
      | valof resultis 8 end:
            i := 3;
    else
        i := i + 1;
    end;
    print_num(i); newline()
end.