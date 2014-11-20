#include <iostream>
#include <vector>
using namespace std;

vector<int> factor(int a){
	vector<int> ret;
	for (int i = 2; i <= a; i++){
		if (a%i == 0){
			ret.push_back(i);
		}
	}
	return ret;
}
bool compare(int a, vector<int> sorted, int low, int high){
	int indx = (low + high) / 2;
	if (low > high){
		return false;
	}
	if (sorted[indx] == a){
		return true;
	}
	if (sorted[indx] > a){
		return compare(a, sorted, low, indx - 1);
	}
	if (sorted[indx] < a){
		return compare(a, sorted, indx + 1, high);
	}
}
int main(){
	int prime1, prime2;
	cin >> prime1 >> prime2;
	int n = prime1*prime2;
	int phi = (prime1 - 1)*(prime2 - 1);
	int e;
	bool cont = true;
	vector<int> nfac, efac;
	nfac = factor(n);
	for (int i = 2; i < phi; i++){
		efac = factor(i);
		for (int j = 0; j < nfac.size(); j++){
			if (compare(nfac[j], efac, 0, efac.size() - 1)){
				cont = false;
			}
		}
		
	}
	return 0;
}