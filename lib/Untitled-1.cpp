#include<iostream>
using namespace std;
int main(){
    int t,n,x=0;
    cin>>t;
    while(t>0)){
        cin>>n;
        int a[n];
        for(int i=0;i<n;i++){
            cin>>a[i];
            for(int i=0;i<n;i++){
                if(a[i]>a[i+1])
                {
                    cout<<"yes";
                }
                else
                {
                  x++;
                }
                if(x>0)
                cout<<"No";
            }
        }
    }

}