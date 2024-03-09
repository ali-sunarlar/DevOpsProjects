# Create, View, and Edit Text Files

## Redirect Output to a File or Program

çıktıyı veya hata bir dosyaya yonlendirmek icin

### Standard Input, Standard Output, and Standard Error


Channels (File Descriptors)

| Number | Channel name    | Description    | Default connection    | Usage    |
|--|--|--|--|--|
| 0 | stdin | Standard input | Keyboard | read only |
| 1 | stdout| Standard output | Terminal | write only |
| 2 | stderr | Standard error | Terminal | write only |
| 3+ | filename | Other files | none | read, write, or both |


### Redirect Output to a File

Output Redirection Operators
| Usage  | Explanation    |
|--|--|
| > file | Redirect stdout to overwrite a file. |
| >> file | Redirect stdout to append to a file. |
| 2> file | Redirect stderr to overwrite a file. |
| 2> /dev/null | Discard stderr error messages by redirecting them to /dev/null. |
| > file 2>&1 | Redirect stdout and stderr to overwrite the same file. |
| &> file | Redirect stdout and stderr to overwrite the same file. |
| >> file 2>&1 | file Redirect stdout and stderr to append to the same file. |
| &>>  | file Redirect stdout and stderr to append to the same file. |