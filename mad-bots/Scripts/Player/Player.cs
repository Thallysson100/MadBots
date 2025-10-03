using Godot;
using System;
using System.Numerics;

public partial class Player : CharacterBody2D
{
	public override void _Process(double delta)
	{
		movement((float) delta);
	}
	public void movement(float delta)
	{
		float velocity = 300.0f * delta;
		Godot.Vector2 vector = new(0, 0);
		if (Input.IsKeyPressed(Key.W) || Input.IsKeyPressed(Key.Up))
		{
			vector.Y += -1;
		}
		if (Input.IsKeyPressed(Key.S) || Input.IsKeyPressed(Key.Down))
		{
			vector.Y += 1;
		}
		if (Input.IsKeyPressed(Key.D) || Input.IsKeyPressed(Key.Right))
		{
			vector.X += 1;
		}
		if (Input.IsKeyPressed(Key.A) || Input.IsKeyPressed(Key.Left))
		{
			vector.X += -1;
		}
		vector = vector.Normalized();
		this.Position += vector * velocity;
	}
}
