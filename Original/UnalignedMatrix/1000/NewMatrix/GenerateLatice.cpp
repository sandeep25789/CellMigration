#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<math.h>

#define PI 3.14159265358979

void generateMatrix(int, int, int, int, int, double);
int generateLine(int, int, int, int, int, int*);

//500,500,1000,15,20,-1.0

int main()
{
	generateMatrix(500,500,600,15,20,-1.0);
}

void generateMatrix(int rows, int cols, int noOfFibers, int minLengthOfFiber, int maxLengthOfFiber, double originalAlignment)
{

	int FiberPos[rows][cols];

	// Initialize the ECM fiber data
	for(int i =0;i<rows;i++)
	{
		   for(int j=0;j<cols;j++)
		   {

			FiberPos[i][j] = 0;

		   }
	}


	int x,y,x2,y2;
	int length;
	time_t t;
	double alignment;

	srand((unsigned) time(&t));
	/* Initializes random number generator */
	
	int cellID = 1;

	for (int fibreID = 1; fibreID <= noOfFibers; fibreID++) 
	{
		alignment = originalAlignment;
		length = minLengthOfFiber+rand()%(maxLengthOfFiber-minLengthOfFiber);

		printf("\nlength = %d\n",length);

		x = length+rand() % (cols-2*length);
		y = length+rand() % (rows-2*length);

		int * points = new int[length*9*2];

		printf("\nalignment = %lf\n",alignment);

		if(alignment<0.0)
		{
			alignment = double(rand()%10)/3.0;
		}

		printf("\nAngle=%lf\n", alignment);

		//Calculating end points and generating line
		x2 = (int) round((double) x + (length - 1) * cos(alignment));
		y2 = (int) round((double) y + (length - 1) * sin(alignment));
		int pointCount = generateLine(x, y, x2, y2, length, points);
		
		printf("\nx=%d y=%d x2=%d y2=%d\n",x,y,x2,y2);

		// Populate the fiber database
		for(int j=0;j<pointCount;j++)
		{
			int p=points[j*2+0];
			int q=points[j*2+1];

			FiberPos[p][q] = FiberPos[p][q]+1;
		}
	}

	/*FILE *fp = fopen("Data.csv","a+");
	for(int i=0;i<rows;i++)
	{
		for(int j=0;j<cols;j++)
		{
		        fprintf(fp,"%d,",FiberPos[i][j]);
		}
	        fprintf(fp,"\n");
	}
	fclose(fp);

	printf("Write data to file\n");
		//Write data to piff file
		for(int i =0;i<rows;i++)
		{
		   for(int j=0;j<cols;j++)
		   {
			{
				if(FiberPos[i][j] > 0)
				{
					FILE *fp = fopen("Lattice_1000Fibrers2.piff","a+");
					fprintf(fp,"%d Matrix %d %d %d %d 0 0\n",cellID,i,i,j,j);
					fclose(fp);
					cellID++;
				}
			}
		   }
                }
	*/

	//Remove 50% crossections
	for(int i =0;i<rows;i++)
	{
	   for(int j=0;j<cols;j++)
	   {
		if(FiberPos[i][j] > 1)
		{
			printf("Remove crossections FiberPos>1.\n");
			double random = ((double)(rand()%100))/100.0;
			if(random > 0.5)
			{
				//printf("Remove crossections -5.\n");
				for(int m=-5;m<=5;m++)
				{
					for(int n=-5;n<=5;n++)
					{
						if(((i+m) >= 0 ) && ((i+m) <rows) && ((j+n) >= 0) && ((j+n) <cols))
						{ FiberPos[i+m][j+n] = 0; 
						 // printf("Remove crossections.\n");
						}
							
					}
				}
				
			}
		 }
	    }
	}

	/*fp = fopen("Data2.csv","a+");
	for(int i=0;i<rows;i++)
	{
		for(int j=0;j<cols;j++)
		{
		        fprintf(fp,"%d,",FiberPos[i][j]);
		}
	        fprintf(fp,"\n");
	}
	fclose(fp);*/

		printf("Write data to file\n");
		//Write data to piff file
		for(int i =0;i<rows;i++)
		{
		   for(int j=0;j<cols;j++)
		   {
			{
				if(FiberPos[i][j] > 0)
				{
					FILE *fp = fopen("Lattice_600Fibrers.piff","a+");
					fprintf(fp,"%d Matrix %d %d %d %d 0 0\n",cellID,i,i,j,j);
					fclose(fp);
					cellID++;
				}
			}
		   }
                }
	
}

int generateLine(int x0, int y0, int x1, int y1, int lengthOfFiber, int * points)
{
	//printf("%d %d %d %d\n",x0, y0,x1,y1);
	int totalPoints=0;
	int sx, sy;
	int dx = abs(x1-x0);
	int dy = abs(y1-y0);
	if(x0 < x1) sx = 1;
	else sx = -1;
	if(y0 < y1) sy = 1;
	else sy = -1;
	int   err = dx-dy;

	while(1){
		//plot(x0,y0)
		//printf("%d %d\n",x0,y0);
		points[totalPoints*2+0]=x0;
		points[totalPoints*2+1]=y0;
		totalPoints++;
		if(x0 == x1 and y0 == y1) break;
		int e2 = 2*err;
		if (e2 > -dy)
		{
			err = err - dy;
			x0 = x0 + sx;
		}
		if (x0 == x1 && y0 == y1)
		{
			//printf("%d %d\n",x0,y0);
			points[totalPoints*2+0]=x0;
			points[totalPoints*2+1]=y0;
			totalPoints++;
			break;
		}

		if(e2 <  dx){
			err = err + dx;
			y0 = y0 + sy;
		}
	}

	return totalPoints;
}
