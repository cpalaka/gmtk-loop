extends Camera2D

@export var screen_drag_margin := 20.0
@export var screen_drag_speed := 1000.0

func _process(delta: float) -> void:
    var viewport = get_viewport()
    var mouse_pos = viewport.get_mouse_position()
    var screen_size = get_viewport_rect().size
    var speed = screen_drag_speed * delta

    # print(mouse_pos)
    if mouse_pos.x >= screen_size.x - screen_drag_margin:
        position.x += speed
    if mouse_pos.x <= screen_drag_margin:
        position.x -= speed

    if mouse_pos.y >= screen_size.y - screen_drag_margin:
        position.y += speed
    if mouse_pos.y <= screen_drag_margin:
        position.y -= speed
