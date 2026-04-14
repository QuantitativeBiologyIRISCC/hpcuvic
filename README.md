# hpcuvic
Manual del cluster de la UVic-UCC per a tots els usuaris.
Accedir al manual: <https://quantitativebiologyiriscc.github.io/hpcuvic/>

Accés al tutorial per connectar-te via vpn <https://universitatdevic-my.sharepoint.com/:w:/g/personal/roger_casals_uvic_cat/IQDQoahT7YNaRJxebaX9Eu7SAYsYy3zio19EIM2xVRd76FQ?e=NsyFzn>

Trobaràs una breu explicació de què és un cluster i de les prestacions que té el de la UVic, com connectar-te, com enviar una "job", comandaments bàsics per controlar els teus treballs, també tutorials per a fer servir les eines disponibles al cluster.

Accés al manual en anglès: utilitza la pestanya de llengua de la pàgina principal.
Accés als tutorials per a programes específics:

- Scripts d'exemple Slurm: carpeta `exemples/`
- Manuals i contingut principal: fitxer `index.html`

Com afegir un nou tutorial:

1. Afegeix el fitxer nou al directori adequat del repositori.
   - Si és un script Slurm o un exemple executable, desa'l a `exemples/`.
   - Si és documentació general del manual, afegeix la secció corresponent a `index.html`.
   - Si cal material addicional com PDF o imatges, desa'l a `imatges/`.

2. Enllaça el nou contingut des de `index.html`.
   - Afegeix una entrada a l'índex de navegació en català i en anglès si el contingut ha d'aparèixer al menú.
   - Crea una nova secció amb un `id` propi si és un tutorial nou dins del manual.
   - Si només és un fitxer descarregable, afegeix-ne l'enllaç a la secció d'exemples o a la secció temàtica corresponent.

3. Mantén la coherència entre llengües.
   - Si afegeixes una secció nova al bloc en català, afegeix també la versió equivalent al bloc en anglès.
   - Si el contingut només existeix en un idioma, deixa com a mínim l'enllaç i una descripció clara.

4. Revisa les rutes i els noms dels fitxers.
   - Fes servir rutes relatives, per exemple `exemples/nom_script.slurm`.
   - Evita espais o noms ambigus als fitxers.

5. Comprova el resultat abans de publicar.
   - Obre `index.html` al navegador i valida que l'enllaç nou funcioni.
   - Revisa que el nou tutorial aparegui al menú correcte i que no hagi trencat la navegació.

