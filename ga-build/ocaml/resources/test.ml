open Core.Std

let main () =
  let s = String.concat ~sep:" " ["Hello,"; "world!"] in
  Printf.printf "%s\n" s

let () =
  main ()
