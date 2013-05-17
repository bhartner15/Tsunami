#include <MeggyJrSimple.h>

//Things to work on: start up screen, restarting the game

struct Point
{
  int x;                      
  int y;
  boolean isApproaching;      //creates a way to see if an obsacle is approaching
};

Point o1 = {0,7,false};        //all points in the array
Point o2 = {2,7,false};
Point o3 = {3,7,false};
Point o4 = {4,7,false};
Point o5 = {5,7,false};
Point o6 = {7,7,false};
Point o7 = {7,7,false};
Point o8 = {0,7,false};
Point o9 = {1,7,false};
Point o10 = {2,7,false};
Point o11 = {3,7,false};
Point o12 = {4,7,false};
Point o13 = {5,7,false};
Point o14 = {7,7,false};
Point o15 = {7,7,false};
Point o16 = {0,7,false};
Point o17 = {1,7,false};
Point o18 = {2,7,false};
Point o19 = {3,7,false};
Point o20 = {4,7,false};
Point o21 = {5,7,false};
Point o22 = {7,7,false};
Point o23 = {7,7,false};

Point obstacleArray[24] = {o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15,o16,o17,o18,o19,o20,o21,o22,o23};
                          //declared all points in the array


byte xp,yp; //define two 8-bit unsigned variable
            //for player poisition ('xc' and 'yc')
            //(a byte can have a value 0 - 255)

int xtsunami[8] = {0,0,0,0,0,0,0,0}; //set up for tsunami line
int ytsunami[8] = {0,1,2,3,4,5,6,7};

int xground[7] = {1,2,3,4,5,6,7}; //set up for ground line
int yground[7] = {0,0,0,0,0,0,0};

int xtbarrier[7] = {1,2,3,4,5,6,7}; //set up for top barrier
int ytbarrier[7] = {7,7,7,7,7,7,7};

int lives = 3; //set up lives

int ObstaclesPassed = 0; //how many obstacles the player has passed

int dice = (int) random (24);       //sets up a "dice" that will randomly pick a number between 0-24)

int counter = 0;            //sets up counter

void setup()
{
  MeggyJrSimpleSetup();
  ClearSlate();
  SetAuxLEDsBinary(B00000000); //sets up LEDs
  Start();
  DrawStandard(); //draws standard scenery such as barriers
  xp = 2;
  yp = 1;
  DrawPx(xp,yp,Red);     //initial setup for player 
  DisplaySlate();
  
}

void loop()
{
  dice = (int) random (24);
  if (counter > 10) counter = 0;
  {
    counter++;
    Obstacle();
  }
  
  CheckButtonsPress();
  if(Button_Up)
    {
      yp = yp + 1;
      if(yp == 7)
        yp = 7;
    }
  if(Button_Down)
    {
      yp = yp - 1;
      if(yp == 0)
        yp = 1;
    }
  if (Button_Left)
    {
      xp = xp - 1;
      if(xp == 0)
      {
        lives = lives - 1;
        lifelights();
        xp = 1;
      } 
    }
  if(Button_Right)
    {
      xp = xp + 1;
      if(xp == 7)
        xp = 7;
    }
    
    ClearSlate();
    DrawPx(xp,yp,Red);
    CheckCollision();
    Speed();
    DisplaySlate();
    
}

void DrawStandard()
{
  for (int b=14;b>1;b--)
  {
    DrawPx(xtsunami[b],ytsunami[b],15);
    DrawPx(xground[b],yground[b],14);
    DrawPx(xtbarrier[b],ytbarrier[b],14);
  }
}

void lifelights()
{
        if (lives == 3)
        {
          SetAuxLEDsBinary(B11100000);
        }
        if (lives == 2)
        {
          SetAuxLEDsBinary(B11000000);
        }
        if (lives == 1)
        {
          SetAuxLEDsBinary(B10000000);
        }
        if (lives == 0)
        {
          SetAuxLEDsBinary(B00000000);
        }
        if (lives == -1)
        {
          Tone_Start(ToneF3,50);           //death sound
          delay(50);
          Tone_Start(ToneF3,50);
          delay(50);
          Tone_Start(ToneF3,150);
          ClearSlate();                  //restarts game
          SetAuxLEDsBinary(B11100000); //resets LEDs
          DrawStandard(); //draws standard scenery such as barriers
          xp = 2;            //resets player's position
          yp = 1;
          DrawPx(xp,yp,Red);     
          DisplaySlate();
        }
}

void CheckCollision()
{
  if (xp == obstacleArray[0].x && yp == obstacleArray[0].y)
  {
    lives = lives - 1;
    Tone_Start(ToneF3,50);
    obstacleArray[0].isApproaching = false;             //set the boolean flag back to false   
    obstacleArray[0].x = 7;                        // putting all the out of play dots to a neat little corner
    obstacleArray[0].y = 7;
  }
}

void Obstacle()
{
 if (obstacleArray[dice].isApproaching == false) //rolls the dice if there is nothing in that column
  {
    obstacleArray[dice].isApproaching = true;
    obstacleArray[dice].x = random(8);
    obstacleArray[dice].y = 7;
  } 
  for (int i = 0; i < 24; i++)                //if the cube is in play (isFalling), 
    {
      if (obstacleArray[i].isApproaching == true)              //if an obstacle is approaching
      {
        if (counter%2 == 0)                          // % modulus, this allows obstacles to move at half speed according to the player
          obstacleArray[i].y--;                            //minus one from the Y so it will continuously come at you
          
          if (obstacleArray[i].y < 0)                      //if they y value of the dot is less than 0
          {  
           obstacleArray[i].isApproaching = false;             //set the boolean flag back to false   
           obstacleArray[i].x = 7;                        // putting all the out of play dots to a neat little corner
           obstacleArray[i].y = 7;
           ObstaclesPassed++;
          }
          
          DrawPx(obstacleArray[i].x, obstacleArray[i].y, Green);      //draws the obstacles in green
      }
    }
}

void Speed() //sets speed according to how many obstacles have passed
{
  if (ObstaclesPassed >= 0)
  {
    if (ObstaclesPassed <= 7)
    {
    delay (300);
    }
    if (ObstaclesPassed >= 8)
    {
      if (ObstaclesPassed <= 15)
      {
        delay (250);
      }
      if (ObstaclesPassed >= 16)
      {
        if (ObstaclesPassed <= 23)
        {
          delay (200);
        }
        if (ObstaclesPassed >= 24)
        {
          if (ObstaclesPassed <= 31)
          {
            delay (150);
          }
          if (ObstaclesPassed >= 32)
          {
            delay (100);
          }
        }
      }
    }
  }
}

Start()
{
  //start up screen
}

