open Graphics;;

type view = {
  height: int;
  color: Graphics.color;
  children: children list;
} and text = {
  height: int;
  color: Graphics.color;
  text: string;
} and children = View of view | Text of text;;

type context = {
  y: int;
  width: int;
  height: int;
  is_root: bool;
};;

let render_view = fun context (element: view) ->
  set_color element.color;
  draw_rect 0 (context.height - context.y - element.height) (context.width - 1) (element.height - 2);;

let render_text = fun context (element: text) ->
  set_color element.color;
  let x = fst (text_size element.text) in
    moveto (context.width / 2 - x / 2) (context.height - context.y - element.height);
  draw_string element.text;;

let rec render context element =
  if context.is_root = true then
    clear_graph ();
  match element with
    | Text element ->
      render_text context element;
      { context with y = context.y + element.height };
    | View element ->
      render_view context element;
      let next_context = List.fold_left
        (fun context child ->
          render ({ context with is_root = false }) child;
        )
        context
        element.children in
      { next_context with y = context.y + element.height };
;;


let width = 300;;
let height = 500;;

open_graph "";;
set_window_title "ComponentML";;
resize_window width height;;

let base_context = {
  y = 0;
  width = width;
  height = height;
  is_root = true;
};;

let tree = View {
  height = height;
  color = 0xFF0000;
  children = [
    View {
      height = 100;
      color = 0x0000FF;
      children = [
        Text {
          color = 0xFF0000;
          text = "HelloWorld!";
          height = 20;
        };
        Text {
          color = 0x00FF00;
          text = "Second!";
          height = 50;
        };
        Text {
          color = 0x0000FF;
          text = "Third!";
          height = 30;
        };
      ];
    };
    View {
      color = 0x00FF00;
      height = 40;
      children = [
        Text {
          color = 0x00FFFF;
          height = 20;
          text = "Ok";
        };
      ];
    };
  ];
};;

let _ =
  render base_context tree;
  (* Used not to exit immediately *)
  ignore( wait_next_event [ Key_pressed ] );;
