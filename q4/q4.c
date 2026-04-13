#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[50];
    int num1, num2;

    while (1) {
        int inp = scanf("%s %d %d", op, &num1, &num2);
        if (inp != 3) break;

        char libname[50];
        strcpy(libname, "lib");
        strcat(libname, op);
        strcat(libname, ".so");

        void *handle = dlopen(libname, RTLD_LAZY);

        if (handle == NULL) {
            printf("Lib %s not found\n", libname);
        } else {

            int (*func)(int, int);

            void *sym = dlsym(handle, op);
            func = (int (*)(int, int)) sym;

            if (func == NULL) {
                printf("Function %s not found\n", op);
                dlclose(handle);
            } else {

                int result = 0;
                result = func(num1, num2);

                printf("%d\n", result);

                dlclose(handle);
            }
        }
    }

    return 0;
}