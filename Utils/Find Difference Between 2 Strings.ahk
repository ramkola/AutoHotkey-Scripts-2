string1 = fuck
string2 = Fuck

string_array1 := strsplit(string1) 
string_array2 := strsplit(string2) 

for i, j in string_array1
{
    if (string_array2[i] == j)
        1=1
    else
    {
        OutputDebug, % Format("Character position #{:02}) ", i) j 
        break
    }
}

OutputDebug, % "string1: " substr(string1,1,i)
OutputDebug, % "string2: " substr(string2,1,i)

