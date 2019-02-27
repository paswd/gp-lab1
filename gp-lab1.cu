#include <iostream>
#include <algorithm>

using namespace std;

__global__ void VectorsPairMaximums(double *first, double *second, double *res) {
	size_t current = (size_t) threadIdx.x;

	res[current] = max(first[current], second[current]);
}

__host__ int main(void) {
	size_t size;
	cin >> size;

	double *first = new double[size];
	double *second = new double[size];
	double *res = new double[size];

	for (size_t i = 0; i < size; i++) {
		cin >> first[i];
	}
	for (size_t i = 0; i < size; i++) {
		cin >> second[i];
	}

	double *cudaFirst;
	double *cudaSecond;
	double *cudaRes;

	cudaMalloc((void**) &cudaFirst, sizeof(double) * size);
	cudaMalloc((void**) &cudaSecond, sizeof(double) * size);
	cudaMalloc((void**) &cudaRes, sizeof(double) * size);

	cudaMemcpy(cudaFirst, first, sizeof(double) * size, cudaMemcpyHostToDevice);
	cudaMemcpy(cudaSecond, second, sizeof(double) * size, cudaMemcpyHostToDevice);

	VectorsPairMaximums<<<1, size>>>(cudaFirst, cudaSecond, cudaRes);

	cudaEvent_t syncEvent;

	cudaEventCreate(&syncEvent);
	cudaEventRecord(syncEvent, 0);
	cudaEventSynchronize(syncEvent);

	cudaMemcpy(res, cudaRes, sizeof(double) * size, cudaMemcpyDeviceToHost);

	//double *testArr = new double[size];
	//cudaMemcpy(testArr, cudaFirst, sizeof(double) * size, cudaMemcpyDeviceToHost);

	cudaEventDestroy(syncEvent);
	cudaFree(cudaFirst);
	cudaFree(cudaSecond);
	cudaFree(cudaRes);

	for (size_t i = 0; i < size; i++) {
		if (i > 0) {
			cout << " ";
		}
		cout << scientific << res[i];
	}
	cout << endl;

	delete [] first;
	delete [] second;
	delete [] res;

	return 0;
}