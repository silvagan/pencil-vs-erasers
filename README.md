### This is a 3D FPS game where your main purpose is to keep the biggest postion of the page covered in paint possible whilst fighting off waves of angry destructive erasers.

## Game start
when you begin the game you are placed on the notebook page:
<table border="0" align="center">
  <tr>
    <td><img width= "500" src="https://github.com/user-attachments/assets/25ae9b52-a09e-4d50-90aa-b708f21f54bc" alt="test")</td>
  </tr>
</table>

Firstly I'll provide a short explanation of the things you see on screen:
<table border="0" align="center">
  <tr>
    <td>On your top left you see the current percentage of the board covered, the current wave's contents and the time left until the next wave:</td>
    <td><img width= "200" src="https://github.com/user-attachments/assets/184c4ca6-a243-43c9-9f1e-372b33e4f8f5" alt="covered margin and next wave")</td>
  </tr>
  <tr>
    <td>In the middle of your left you see your player stats:</td>
    <td><img width= "200" src="https://github.com/user-attachments/assets/2034b8e4-9654-486d-9218-e044579d6abf" alt="player stats")</td>
  </tr>
  <tr>
    <td>on the right side you see the controls for the game:</td>
    <td><img width= "200" src="https://github.com/user-attachments/assets/8f221d0e-e880-40de-b1aa-6b5310430cab" alt="controls")</td>
  </tr>
  <tr>
    <td>and lastly in the middle of the screen you see a crosshair that also represents the reload time of your "shoot" ability:</td>
    <td><img width= "200" src="https://github.com/user-attachments/assets/9bc0798f-a63a-4968-ab28-e49ff30341e6" alt="crosshair")</td>
  </tr>
</table>

#### The gameplay
As you play the game, swarms of enemies will come your way. Your task is to survive and at the same time keep as big of a portion of the canvas drawn over as possible.
Any collision with an enemy and youre out.

You can color the canvas by either moving and staying on the ground or shooting pellets.
<table border="0" align="center">
  <tr>
    <td><img width= "400" src=https://github.com/user-attachments/assets/0feda979-0b9f-4102-b819-4e903f0618e1 alt="you leave a trail")</td>
    <td><img width= "400" src=https://github.com/user-attachments/assets/880f5f0a-6b4c-4508-a9b4-e56732cac7f4 alt="your pellets leave a trail")</td>
  </tr>
</table>

The erasers all remove your markings from the ground, be it intentionally or accidentaly.
You can color the canvas by either moving and staying on the ground or shooting pellets.

<table border="0" align="center">
  <tr>
    <td><img width= "400" src=https://github.com/user-attachments/assets/13999f0d-1ea3-4842-b718-aaa635709697 alt="erasers do their job")</td>
  </tr>
</table>

Currently there are three kinds of erasers:

<p align="center">
  the Idler
</p>
<table border="0" align="center">
  <tr>
    <td>The Idler is the laziest of the bunch. It mainly wanders in seemingly random directions, sometimes stopping to contemplate existance. When the player is moving at high speeds might catch the player unaware.</td>
    <td><img width= "500" src=https://github.com/user-attachments/assets/25d9b458-401c-4f44-bdce-81c3ee85ed0b alt="idler idling")</td>
  </tr>
</table>
<p align="center">
  the Chaser
</p>
<table border="0" align="center">
  <tr>
    <td>The Chaser's name is quite self explanatory. It at all times moves towards the player in some cases proving to be quite hard to avoid</td>
    <td><img width= "500" src=https://github.com/user-attachments/assets/b7c012df-d3ca-4e41-ae6d-b55478d2f9d3 alt="Chaser chasing")</td>
  </tr>
</table>
<p align="center">
  and lastly the only one who tries to do his job, the Spiraling
</p>
<table border="0" align="center">
  <tr>
    <td>The spiraling excells in one thing - that is removing your markings and tanking your score. Although he does not directly seek out the player, he still eventually finds his way.</td>
    <td><img width= "500" src=https://github.com/user-attachments/assets/df1e1d3a-cc89-44e0-b920-be4feaad3b8c alt="end")</td>
  </tr>
</table>
All erasers take damage either from erasing your marks off the ground or from you shooting them (the latter being more efective)
The game ends when you touch some eraser or fall off the map.
And lastly, according to your performance you get a score:
<table border="0" align="center">
  <tr>
    <td> <img width= "500" src="https://github.com/user-attachments/assets/618400f4-4772-4f92-9997-a7b391c22a02" alt="test")</td>
  </tr>
</table>
