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
