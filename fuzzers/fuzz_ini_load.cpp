#include <inicpp.h>
#include <string.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    ini::IniFile myIni;
    myIni.load(argv[1]);
    printf("ini loaded");
}
