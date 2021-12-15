var a, b: array 10 of integer;

proc swap(i: integer);
    var x: integer;
begin
    x := a[i];
    a[i] := b[i];
    b[i] := x
end;

begin
    swap(3)
end.