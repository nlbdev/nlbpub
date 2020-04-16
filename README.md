# NLBPUB

NLBPUB er NLBs profil for å produsere universelt utformet EPUB.

## Varianter

Revisjoner av skjemareglene finnes i "schema"-mappen.

### revision-2018

Dette er resultatet etter en full gjennomgang av skjemareglene
i 2018. Vi har ikke tatt i bruk disse først og fremst fordi:

- retningslinjene må revideres tilsvarende
- valideringsreglene bør dokumenteres (helst genereres automatisk basert på kildekoden)
- eksisterende bøker må gjøres valide i henhold til disse reglene

### nlbpub-v1

Dette er i praksis de samme reglene som gjelder for "single-html" i de nordiske retningslinjene.
Den eneste forskjellen er at det her ikke kreves et `<header>`-element,
som brukes for å konvertere `<doctitle>` og `<docauthor>` mellom DTBook og HTML/EPUB.
