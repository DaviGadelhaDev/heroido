extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
@onready var animation = $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@export var player_life := 5  # Definindo o número de vidas do jogador
var knockback := Vector2.ZERO
var is_hurted := false
var fruits_collected := 0  
var burgers_collected := 0  
var direction # Variável global para a direção

func _physics_process(delta: float) -> void:
	# Aplica gravidade se não estiver no chão
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salta se o jogador pressionar o botão e estiver no chão
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Obtém a direção do movimento horizontal
	direction = Input.get_axis("ui_left", "ui_right")  # Usando a variável global

	# Movimentação horizontal
	if direction != 0:
		velocity.x = direction * SPEED  

		# Atualiza a animação para "corrida"
		if not animation.is_playing() or animation.animation != "run":
			animation.play("run")
			animation.scale.x = direction  # Espelha a animação
	else:
		velocity.x = 0  
		# Atualiza a animação para "parado"
		if not animation.is_playing() or animation.animation != "idle":
			animation.play("idle")  

	# Aplica o knockback, se existir
	if knockback != Vector2.ZERO:
		velocity = knockback
	_set_state()
	move_and_slide()

# Função chamada quando o jogador colide com algo
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		# Jogador matando o inimigo ao pular sobre ele
		if velocity.y > 0 and global_position.y < body.global_position.y:  # Verificando se o jogador está caindo
			print("Você matou o inimigo!")
			body.queue_free()  # Remove o inimigo
			velocity.y = JUMP_VELOCITY  # Faz o jogador "quicar"
		elif global_position.x > body.global_position.x + 10 or global_position.x < body.global_position.x - 10:  # Verifica colisão lateral
			# Jogador colidiu lateralmente com o inimigo
			print("Você morreu ao colidir com o inimigo lateralmente!")
			if player_life > 0:  # Verifica se o jogador ainda tem vidas antes de causar dano
				take_damage(Vector2(200, -200))  # Chama a função de dano
			if player_life <= 0:
				_die()  # Chama a função de morte se as vidas forem zero ou menos

	elif body.is_in_group("fruit"):
		print("Você coletou uma fruta!")
		fruits_collected += 1  
		print("Frutas coletadas: ", fruits_collected) 
		body.queue_free()  

	elif body.is_in_group("burger"):
		print("Você coletou um hambúrguer!")
		burgers_collected += 1  
		print("Hambúrgueres coletados: ", burgers_collected)  
		body.queue_free()  
		print("Você morreu! Coletou um hambúrguer!")
		if player_life > 0:  
			take_damage(Vector2(200, -200))  
		if player_life <= 0:
			_die()  

# Função de dano e knockback
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	knockback = knockback_force
	player_life -= 1  

	if player_life <= 0:
		_die() 
	else:
		if $Ray_right.is_colliding():
			take_damage(Vector2(-200, 200))  
		elif $Ray_left.is_colliding():
			take_damage(Vector2(200, -200))  

	var knockback_tween = create_tween() 
	knockback_tween.parallel().tween_property(self, "knockback", Vector2.ZERO, duration)
	animation.modulate = Color(1,0,0,1)
	knockback_tween.parallel().tween_property(animation,"modulate",Color(1,1,1,1,),duration)


	is_hurted = true
	if is_inside_tree():
		await get_tree().create_timer(0.3).timeout
	is_hurted = false
	
func _die() -> void:
	print("Você morreu!")
	if is_inside_tree():
		get_tree().change_scene_to_file("res://actors/game_over.tscn")  
	queue_free()

func _set_state():
	var state = "idle"
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	if is_hurted:
		state = "hurt"	
	if animation.name != state:
		animation.play(state)
