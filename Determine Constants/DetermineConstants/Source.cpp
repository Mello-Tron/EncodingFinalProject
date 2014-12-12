// Program to print all prime factors
//Pulled barebones primeFactors function from http://www.geeksforgeeks.org/print-all-prime-factors-of-a-given-number/
#include <iostream>
# include <stdio.h>
# include <math.h>
#include <vector>
using namespace std;

void primeFactors(int n, vector<int>& factors)
{
	int check = 0;

	// Print the number of 2s that divide n
	while (n % 2 == 0)
	{
		cout << "2 ";
		check = 0;
		for (int i = 0; i < factors.size(); i++)
		{
			if (factors[i] == 2)
			{
				check += 1;
			}
		}
		if (check < 2)
		{
			factors.push_back(2);
		}
		n = n / 2;
	}

	// n must be odd at this point.  So we can skip one element (Note i = i + 2)
	for (int i = 3; i <= sqrt(static_cast<double>(n)); i = i + 2)
	{
		// While i divides n, print i and divide n
		while (n%i == 0)
		{
			cout << i << " ";
			check = 0;
			for (int j = 0; j < factors.size(); j++)
			{
				if (factors[j] == i)
				{
					check = 1;
				}
			}
			if (check == 0)
			{
				factors.push_back(i);
			}
			n = n / i;
		}
	}

	// This condition is to handle the case whien n is a prime number
	// greater than 2
	if (n > 2)
	{
		cout << n << " ";
		check = 0;
		for (int i = 0; i < factors.size(); i++)
		{
			if (factors[i] == n)
			{
				check = 1;
			}
		}
		if (check == 0)
		{
			factors.push_back(n);
		}
	}
}

int main()
{
	char exit = 'y';
	while (exit != 'n')
	{
		cout << "Please enter the length of your message: ";
		int n = 315; //max size of n: 2147483647
		cin >> n;
		vector<int> factors;
		primeFactors(n, factors);

		int K = 1;
		for (int i = 0; i < factors.size(); i++)
		{
			K *= factors[i];
		}
		K += 1;
		cout << endl;
		cout << "Multiplier & Counter = " << K << endl;

		cout << "Would like to run again? (y or n): ";
		cin >> exit;
	}

	return 0;
}