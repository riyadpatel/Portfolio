#include <stdio.h>
#include <limits.h>

// Function to find the optimal matrix multiplication order
void matrixChainOrder(int p[], int n) {
    int m[n][n]; // m[i][j] holds the minimum number of multiplications
    int s[n][n]; // s[i][j] holds the index of the optimal split

    // Initializing the diagonal values to 0 as a matrix multiplied by itself has zero cost
    for (int i = 1; i < n; i++) {
        m[i][i] = 0;
    }

    // Applying dynamic programming for chain length L = 2 to n
    for (int L = 2; L < n; L++) {  // L is the chain length
        for (int i = 1; i < n - L + 1; i++) {
            int j = i + L - 1;
            m[i][j] = INT_MAX;
            for (int k = i; k <= j - 1; k++) {
                // Cost of splitting at k
                int q = m[i][k] + m[k + 1][j] + p[i - 1] * p[k] * p[j];
                if (q < m[i][j]) {
                    m[i][j] = q; // Minimum cost
                    s[i][j] = k; // Store the optimal split point
                }
            }
        }
    }

    printf("Minimum number of multiplications needed: %d\n", m[1][n - 1]);
}

// Helper function to print the optimal order of matrix multiplication
void printOptimalParens(int s[][100], int i, int j) {
    if (i == j) {
        printf("A%d", i);
    } else {
        printf("(");
        printOptimalParens(s, i, s[i][j]);
        printOptimalParens(s, s[i][j] + 1, j);
        printf(")");
    }
}

int main() {
    int arr[] = {30, 35, 15, 5, 10, 20, 25}; // Dimensions of matrices
    int n = sizeof(arr) / sizeof(arr[0]);

    int s[100][100]; // Array to store the optimal splits for printing

    matrixChainOrder(arr, n);

    printf("Optimal Parenthesization is: ");
    printOptimalParens(s, 1, n - 1);
    printf("\n");

    return 0;
}
