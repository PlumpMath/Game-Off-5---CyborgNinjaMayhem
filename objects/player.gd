extends KinematicBody2D

const speed = 200
const shootDelay = 0.3

var shootTimer = 0
var velocity = Vector2()
var shuriken = preload("res://objects/shuriken.xml");
var shurikenCount = 0;
func _ready():
    set_fixed_process(true)

func _fixed_process(delta):
    if(shootTimer > 0):
        shootTimer-= delta
    var shurikenScript;
    velocity = Vector2(0,0)

    var upButton = Input.is_action_pressed("ui_up")
    var downButton = Input.is_action_pressed("ui_down")
    var rightButton = Input.is_action_pressed("ui_right")
    var leftButton = Input.is_action_pressed("ui_left")

    var upShootButton = Input.is_action_pressed("ui_shoot_up")
    var downShootButton = Input.is_action_pressed("ui_shoot_down")
    var rightShootButton = Input.is_action_pressed("ui_shoot_right")
    var leftShootButton = Input.is_action_pressed("ui_shoot_left")

    if(leftButton):
        velocity.x += -1
    elif(rightButton):
        velocity.x += 1
    if(upButton):
        velocity.y += -1
    elif(downButton):
        velocity.y += 1

    if((leftShootButton || rightShootButton || upShootButton || downShootButton) && shootTimer <= 0):
        shurikenCount += 1
        var shuriken_instance = shuriken.instance()
        shuriken_instance.set_name("Shuriken"+str(shurikenCount))
        get_parent().add_child(shuriken_instance)
        #use below variable for individual node access.
        var shuriken_instance_node = get_parent().get_node("Shuriken"+str(shurikenCount))
        shuriken_instance_node.add_collision_exception_with(self)
        shuriken_instance_node.set_pos(self.get_global_pos())
        if(leftShootButton):
            shuriken_instance_node.projVelocity += Vector2(-1,0) + (velocity*0.5)
        elif(rightShootButton):
            shuriken_instance_node.projVelocity += Vector2(1,0) + (velocity*0.5)
        if(upShootButton):
            shuriken_instance_node.projVelocity += Vector2(0,-1) + (velocity*0.5)
        elif(downShootButton):
            shuriken_instance_node.projVelocity += Vector2(0,1) + (velocity*0.5)
        shootTimer = shootDelay      

    var motion = velocity * speed * delta
    move(motion)
    if (is_colliding()):
        var n = get_collision_normal()
        motion = n.slide(motion)
        velocity = n.slide(velocity)
        move(motion)