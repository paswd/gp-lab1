#include <iostream>
#include <algorithm>

using namespace std;

__global__ void VectorsPairMaximums(size_t size, double *first, double *second, double *res) {
	size_t begin = (size_t) (blockDim.x * blockIdx.x + threadIdx.x);
	size_t offset = gridDim.x * blockDim.x;

	for (size_t i = begin; i < size; i += offset) {
		res[i] = max(first[i], second[i]);
	}
}

__host__ int main(void) {
	size_t size;
	cin >> size;

	double *first = new double[size];
	double *second = new double[size];
	double *res = new double[size];

	for (size_t i = 0; i < size; i++) {
		cin >> first[i];
		//first[i] = i;
	}
	for (size_t i = 0; i < size; i++) {
		cin >> second[i];
		//second[i] = i;
	}

	double *cudaFirst;
	double *cudaSecond;
	double *cudaRes;

	cudaMalloc((void**) &cudaFirst, sizeof(double) * size);
	cudaMalloc((void**) &cudaSecond, sizeof(double) * size);
	cudaMalloc((void**) &cudaRes, sizeof(double) * size);

	cudaMemcpy(cudaFirst, first, sizeof(double) * size, cudaMemcpyHostToDevice);
	cudaMemcpy(cudaSecond, second, sizeof(double) * size, cudaMemcpyHostToDevice);

	VectorsPairMaximums<<<256, 256>>>(size, cudaFirst, cudaSecond, cudaRes);

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