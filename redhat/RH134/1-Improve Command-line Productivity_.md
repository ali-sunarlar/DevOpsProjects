# Improve Command-line Productivity

## Write Simple Bash Scripts





### Provide Output from a Shell Script

çıkış kodları

işlemin doğru mu yanlış olduğunu kontrol için çıkış kodları kullanılır

```sh



#!/bin/bash
directory="/root/test"

if[-z "$(ls -A "$directory")"]; then
    echo "Dizin Bos"

else
    echo "Dizin Dolu"
fi


directory="/etc/test"

if [-d "$directory"]; then
    echo "Dizin Mevcut"
else
    echo "Dizin Mevcut Değil"
```



```sh

if [[ $? -ne 0 ]]; then
```



















