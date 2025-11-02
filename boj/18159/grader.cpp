#include<stdio.h>
#include<stdlib.h>
#include"SORT.h"
static int A[8],B[8],T,N,C,Q,M,i,j;
static void myassert(bool chk,int code){
	if(!chk){
		printf("Wrong Answer [%d]",code);
		exit(-1);
	}
}
bool compare(int a,int b){
    printf("[DEBUG] compare(%d, %d): A[%d]=%d, A[%d]=%d\n", a, b, a, A[a], b, A[b]);
	C++;
	myassert(1<=a&&a<b&&b<=N,1);
	return A[a]<A[b];
}
void answer(int a,int b){
    printf("[DEBUG] answer(%d, %d): A[%d]=%d\n", a, b, a, A[a]);
	myassert(1<=a&&a<=N&&1<=b&&b<=N,3);
	myassert(!B[a],4);
	B[a]=1;
	Q++;
	myassert(A[a]==b,6);
}
int main(){
	scanf("%d%d",&T,&N);
	init(T,N);
	for(i=0;i<T;i++){
		C=Q=0;
		for(j=1;j<=N;j++){
			scanf("%d",&A[j]);
			B[j]=0;
		}
		sorting();
		myassert(Q==N,5);
		if(M<C){
			M=C;
		}
	}
	printf("Accept. Max Questions = %d",M);
	return 0;
}
