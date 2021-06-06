# Backend per a la PWA de gestió d'una AMPA

Per poder usar aquest repo necessites tindre prèviament en funcionament un servidor amb [Hasura](https://hasura.io).

Recomanable fer-ho amb docker al vostre propi servidor o VPS, però també podeu fer servir el servei al núvol de [Hasura Cloud](https://cloud.hasura.io/)

Una vegada instal·lat tindrem un _endpoint_ que necessitarem per configurar la migració.

Ara deurem de deshabilitar l'accés web a la consola. ho podem fer amb una variable d'entorn al servidor:

`HASURA_GRAPHQL_ENABLE_CONSOLE=false`

També cal configurar la variable d'entorn:

`FIREBASE_FUNCTIONS_URL` amb la url que ens ha proporcionat la consola de firebase per al nostre _endpoint_ de Firebase Functions.

En el cas de Hasura Cloud, també cal afegir la variable d'entorn:

`HASURA_GRAPHQL_DATABASE_URL` amb el valor del string de connexió de la base de dades de dades d'Heroku que trobareu al panell de Hasura Cloud

Instal·lem [Hasura CLI](https://hasura.io/docs/latest/graphql/core/hasura-cli/install-hasura-cli.html#install-hasura-cli)

`npm install --global hasura-cli`

Editem el fitxer `config.yaml` i canviem l'apartat endpoint pel del nostre servidor.

Reanomeneu el fitxer `.env.example` a `.env` i introduïu la contrasenya d'administrador que heu configurat durant la instal·lació.

I ja podem entrar el _GUI_ si fos necessari fer alguna modificació:

`hasura console`

Abans d'iniciar les migracions necessitarem afegir una extensió de postgreSql necessària per una funció de cerca de text per similitud. Per a fer-ho anem a Hasura Consol a l'apartat SQL i executem:

`CREATE EXTENSION pg_trgm;`

I ja podem iniciar la migració de les metadades i de les taules, així com el seed de les taules de tipus _enum_:

`hasura metadata apply`

`hasura migrate apply --database-name default`

`hasura seed apply --database-name default`

`hasura metadata reload`
