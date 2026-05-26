# code

Carpeta per als scripts de manteniment de la web que no pertanyen a cap altra carpeta funcional.

## Fitxers

- `translate_informative_pages.py`: script per traduir el bloc informatiu més nou d'una pàgina HTML bilingüe cap al bloc antic o pendent de la llengua objectiu.
- `Makefile`: dreceres per comprovar i executar el flux de traducció.

## Flux de treball

1. Actualitza primer la pàgina font, habitualment `index.html` en català.
2. Exporta `OPENAI_API_KEY` i `OPENAI_MODEL` si vols regenerar la traducció automàticament.
3. Executa `make -C code check` per comprovar que la pàgina conté els blocs de llengua esperats.
4. Executa `make -C code translate` per actualitzar el bloc anglès a partir del català.
5. Revisa manualment el resultat abans de publicar, especialment els codis, enllaços i noms propis.
