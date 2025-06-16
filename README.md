# Banco de Dados para Ocorrências Registradas pela PF

Este modelo foi desenvolvido na disciplina de Laboratório de Banco de Dados, o qual contempla os dados do Sistema 
Nacional de Armas (SINARM), fornecidos pela Polícia Federal. Foi utilizado o SGBD Oracle Database, aplicando os 
princípios de normalização 3FN, elaboração de modelos relacionais e lógicos e conhecimentos SQL como um todo.

## Dashboards em Power BI
No fim, cada integrante criou uma _Dynamic_ e uma _Materialized View_, com bases nas quais foram feitos Dashboards
analíticos no Power BI. Cada um deles envolve dados estratégicos diferentes, mas que se complementam.

**OBS:** Para ver os relatórios, é necessário instalar o Power BI em sua máquina.

## Estrutura

- **dashboards/**: Dashboards em Power BI baseados nas _MViews_ de cada integrante.
- **implementacao/**: Scripts para criar o banco.
  - **conexao_admin/**: Scripts de criação dos usuários e permissões.
  - **conexao_auditoria/**: Scripts de criação da auditoria do banco.
  - **conexao_dw/**: Scripts de criação das _Dynamic_ e _Materialized Views_ de cada integrante.
  - **conexao_main/**: Scripts de criação da estrutura principal do banco e do seu historiamento.
    - **executar_depois/**: Script dos triggers da auditoria, que devem ser executados somente após a execução de **conexao_auditoria/**.
- **modelo/**: Aqui você encontra detalhes do modelo relacional do banco.

## Implementação: 

**Ordem pastas**: conexao_admin/ > conexao_main/ > conexao_auditoria > conexao_main/executar_depois/ > conexao_dw/.

**Ordem arquivos**: DDL > Sequence > Trigger > Procedure (quando houver)

