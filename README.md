# Backend per a la PWA de gestió d'una AMPA

Per poder usar aquest repo necessites tindre prèviament en funcionament un servidor amb [Hasura](https://hasura.io).

Recomanable fer-ho amb docker al vostre propi servidor o VPS.

Una vegada instal·lat tindrem un _endpoint_ que necessitarem per configurar la migració.

Ara deurem de deshabilitar l'accés web a la consola. ho podem fer amb una variable d'entorn:

`HASURA_GRAPHQL_ENABLE_CONSOLE=false`

Instal·lem [Hasura CLI](https://hasura.io/docs/latest/graphql/core/hasura-cli/install-hasura-cli.html#install-hasura-cli)

Editem el fitxer `config.yaml` i canviem l'apartat endpoint pel del nostre servidor.

Reanomeneu el fitxer `.env.example` a `.env` i introduïu la contrasenya d'administrador que heu configurat durant la instal·lació.

I ja podem iniciar la migració de les metadades i de les taules, així com el seed de les taules de tipus _enum_:

`hasura metadata apply`

`hasura migrate apply --database-name default`

`hasura seed apply --database-name default`

`hasura metadata reload`

I ja podem entrar el _GUI_ si fos necessari fer alguna modificació:

`hasura console`
