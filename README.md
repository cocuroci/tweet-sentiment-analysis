# Objetivo

Criar um aplicativo que busque tweets de um usuário e analise o sentimento desse tweet.

## Arquitetura

Foi utilizado uma arquitetura baseada em VIP. Utilizei as seguintes camadas:

### Interactor

Camada responsável pela lógia da funcionalidade.

### Presenter

Camara responsável para transformar os dados do interactor para a view.

### ViewController

Camada responsável pelo layout.

### Factory
Camada responsável para criar a cena e configuras as outras camadas.

### Service
Camada responsável pelas requisições.

## Libs utilzadas

- Moya (Camada de requisições)

## Detalhes do projeto

- A implementação dos erros foi feita de forma genéria para facilitar o desenvolvimento.
- Existe um arquivo chamado `Environment` onde o token é a API Key do Twitter e key é a API Key do Google. (necessário atualizar essas variávels para que o app funcione)

## To Do

- Melhorar os erros mostrado para o usuário
- Melhorar informações mostradas na célula da UITableView
- Mostrar o sentimento do texto analisado na própria célula da UITableView (possibilitanto multiplos requests)

## Considerações finais

- Foi utlizada a nova versão da API do Twitter onde busca apenas os tweets mais recentes
- Para analisar o sentimento do texto foi utilizado apenas o score enviado pela API do google
